module SC2
  class Simulator
    autoload :ZergMethods,    "sc2sim/simulator/zerg_methods"
    autoload :TerranMethods,  "sc2sim/simulator/terran_methods"
    autoload :ProtossMethods, "sc2sim/simulator/protoss_methods"
    
    include SC2::Inspection
    omits :completed_actions

    attr_reader :supply, :actions, :workers, :time, :minerals, :gas, :completed_actions, :upgrades
    attr_writer :minerals, :gas
    alias supplies supply
    alias vespene gas

    def initialize(race, &block)
      @time = 0.seconds
      @supply = SC2::SupplyRatio.new(self)
      @actions = SC2::ActionQueue.new
      @minerals = 50
      @gas = 0
      @completed_actions = []
      @upgrades = []
      
      set_race(race)
      init_workers
      init_race if respond_to?(:init_race)
      
      instance_eval &block if block_given?
    end

    def build(unit_or_structure)
      everything.each do |object|
        if object.can_produce?(unit_or_structure)
          return object.produce(self, unit_or_structure)
        end
      end
      
      # we need to wait a while because the production unit or structure may be en route,
      # even though it's not in any visible queue. Example: larva spawn or maxed-out barracks.
      wait 1.second and build unit_or_structure
    rescue SystemStackError
      # this can happen when wait(1.second), above, happens infinitely.
      raise ArgumentError, "Couldn't find any suitable candidate to build #{unit_or_structure.inspect}", caller.uniq
    end
    
    # Returns true if the specified unit or structure is under construction or is in the build queue.
    def building?(unit_or_structure)
      actions.each do |action|
        return action if action.respond_to?(:target) && action.target.class.handle == unit_or_structure
      end
      return false
    end
    
    def add_action(type, unit_or_structure, producer)
      actions.push(SC2::Actions.const_get(type).new(self, unit_or_structure, producer)).last
    end
    
    # Checks if anything in production will eventually add to the supply limit, and then waits for it
    # to complete. If nothing in the action queue will do this, an error is raised.
    def wait_for_supply(qty = 1)
      return if supplies.remaining >= qty
      expected = supplies.remaining
      actions.each do |action|
        expected += action.target.supplies_produced if action.respond_to?(:target)
        if expected >= qty
          return action.and_wait
        end
      end
#      raise SC2::Errors::SupplyUnavailable, "Told to wait for supply, but more supply is not coming"
    end
    
    # Returns true if any workers are gathering the requested resource (:minerals, :gas, or a specific
    # extractor, assimilator or refinery)
    def gathering?(what)
      workers.gathering?(what)
    end
    
    # Attempts to cast the specified spell. If no appropriate spellcasters exist, an error will be raised.
    def cast(name_of_spell)
      units.each do |unit|
        if unit.kind_of?(SC2::Units::Spellcaster) && unit.can_cast?(name_of_spell)
          return unit.cast(self, name_of_spell)
        end
      end
      raise SC2::Errors::MissingSpellcaster, "Couldn't find a spellcaster to cast #{name_of_spell.inspect}"
    end
    
    # Waits for construction of the specified unit or structure to be finished. If the item is not currently
    # in the action queue, an error is raised.
    #
    # Special values:
    #   :supplies   => equivalent to calling #wait_for_supplies
    #   :everything => will wait for all action and build queues to become empty.
    def wait_for(unit_or_structure)
      case unit_or_structure
        when :supplies
          wait_for_supply
        when :everything
          wait(1.second) while !actions.empty?
        else
          actions.each do |action|
            if action.handle == unit_or_structure
              return action.and_wait
            end
          end
          # action not found, but perhaps it already completed??
          if everything.select { |u| u.handle == unit_or_structure }.empty?
            raise SC2::Errors::NotInQueue, "Told to wait for #{unit_or_structure.inspect}, but it is not in the action queue"
          end
      end
    end
    
    # Pays for a given object. Reduces minerals and gas by the object's mineral and gas cost, and raises
    # SC2::Errors::SupplyLimitReached if the object requires more supplies than are available.
    #
    # Note that this method does not actually add the object to #structures or #units.
    def pay_for(game_object)
      wait_for_supply(game_object.supply_consumed)
      if game_object.supplies_consumed > 0 && game_object.supplies_consumed > supplies.remaining
        raise SC2::Errors::SupplyLimitReached, "#{game_object} requires #{game_object.supplies_consumed} (#{supplies.inspect})"
      end
      self.minerals -= game_object.mineral_cost
      self.gas      -= game_object.gas_cost
    end

    # Waits until the specified object is affordable based on its mineral and vespene costs.
    def wait_until_affordable(object)
      min_remaining = object.mineral_cost - minerals
      gas_remaining = object.gas_cost - gas
      min_per_second = income_per_second(:minerals)
      gas_per_second = income_per_second(:gas)
      
      if min_remaining > 0 && min_per_second == 0
        raise ArgumentError, "Waiting for minerals, but minerals aren't being gathered"
      end
      
      if gas_remaining > 0 && gas_per_second == 0
        raise ArgumentError, "Waiting for gas, but gas isn't being gathered"
      end
      
      min_remaining /= min_per_second if min_per_second != 0
      gas_remaining /= gas_per_second if gas_per_second != 0
      
      if min_remaining > 0 && min_remaining > gas_remaining
        wait(min_remaining.to_i+1)
        # because the build queue, which is evaluated during #wait, may have gone and spent all the resources
        # we were saving up.
        wait_until_affordable(object)
      elsif gas_remaining > 0
        wait(gas_remaining.to_i+1)
        # because the build queue, which is evaluated during #wait, may have gone and spent all the resources
        # we were saving up.
        wait_until_affordable(object)
      end
    end

    def income(resource_type = nil)
      case resource_type
        when NilClass, :minerals then workers.minerals(60)
        when :gas then workers.gas(60)
        else raise ArgumentError, "Expected resource_type to be one of :minerals, :gas"
      end
    end

    def income_per_second(resource_type = nil)
      case resource_type
        when :minerals then workers.minerals(1)
        when :gas then workers.gas(1)
        else raise ArgumentError, "Expected resource_type to be one of :minerals, :gas"
      end
    end

    # Adds the specified duration to the game time, then updates things like minerals, completed build actions, etc.
    #
    # If no duration is given, waits until all actions in the action queue have been processed. That's equivalent to
    # "macroing up" and then sitting and waiting for all units to stop moving, all building to cease, etc. Not usually
    # ideal.
    def wait(seconds = nil)
      if seconds && seconds == 0
        evaluate_action_queue
      elsif seconds && seconds > 0
      # is there a better way to do this, in order to remove the loop without losing precision?
        seconds.times do
          all_intervals.each do |interval|
            timing = interval[0]
            block = interval[1]
            if (difference = (@time % timing) - ((@time+1) % timing)) > 0
              difference.times { instance_eval(&block) }
            end
          end
          
          @time += 1.second
          @minerals += workers.minerals(1.second)
          @gas += workers.gas(1.second)
          spellcasters.each { |sp| sp.recharge(1.second) }
          evaluate_action_queue
        end
      else
        wait(1.second) while !actions.empty?
      end
    end

    # Returns all units and structures.
    def everything
      units + structures
    end

    # Returns all structures built up to the current moment in game time. Note that structures
    # that are still under construction are omitted.
    #
    # If type is given, only structures of that type will be returned.
    def structures(type = nil)
      @structures ||= []
      type ? @structures.select { |c| c.kind_of?(type) } : @structures
    end

    # Returns all units built up to the current moment in game time. Note that units that
    # are still under construction are omitted.
    #
    # If type is given, only units of that type will be returned.
    def units(type = nil)
      if type
        if worker_type == type
          return workers
        else
          army(type)
        end
      else
        workers + army
      end
    end
    
    # Returns all spellcasting units.
    def spellcasters
      units(SC2::Units::Spellcaster)
    end
    
    # Returns all non-worker units.
    #
    # If type is given, only structures of that type will be returned.
    def army(type = nil)
      @army ||= []
      type ? @army.select { |c| c.kind_of?(type) } : @army
    end
    
    # Cancels the specified unit or structure in production. If the action
    # has already completed (and therefore no actions match), this will raise
    # an error. Note that if there are multiple copies of a given action,
    # the *last* one will be canceled.
    def cancel(unit_or_structure)
      actions.reverse.each do |action|
        if action.respond_to?(:target) && action.target.class.handle == unit_or_structure
          return action.cancel
        end
      end
      raise SC2::Errors::NotInQueue, "No build order for #{unit_or_structure} to cancel"
    end
    
    # Registers a block to be called every X seconds of game time that elapse.
    # The block is evaluated in the context of the simulator.
    #
    # Example:
    # 
    #   simulator.every 20.seconds do
    #     build :drone
    #   end
    #
    def every(how_often, &block)
      intervals.push([how_often, block])
    end
    
    def intervals
      @intervals ||= []
    end
    
    def all_intervals
      intervals + self.class.intervals
    end
    
    class << self
      def intervals
        @intervals ||= []
      end
      
      def every(how_often, &block)
        intervals.push([how_often, block])
      end
    end

    private
    # Checks the first item in the action queue and sees if the action can be performed
    # right now; if so, the action is processed and removed from the queue, and the next
    # action is evaluated. Actions are evaluated linearly: that is, if the first action
    # in the queue cannot be processed, none of them are.
    def evaluate_action_queue
      return if actions.empty?
      
      # it's an error to assume the first action will complete before the second. If it
      # has a long enough build time, it'll complete after.
      actions.each do |action|
        if action.completed?
          completed_actions.push(action)
          actions.delete(action).trigger!
        end
      end

#      if actions.first.completed?
#        actions.shift.trigger!
#        evaluate_action_queue
#      end
    end
    
    def init_workers
      @workers = SC2::WorkerSet.new(6, worker_type)
    end

    def include(mod)
      (class << self; self; end).send(:include, mod)
    end

    def set_race(race)
      case race
        when :zerg    then include SC2::Simulator::ZergMethods
        when :terran  then include SC2::Simulator::TerranMethods
        when :protoss then include SC2::Simulator::ProtossMethods
        else raise ArgumentError, "Expected race to be one of :zerg, :terran, :protoss"
      end
      @race = race
    end
  end
end