module SC2
  class Simulator
    autoload :ZergMethods,    "sc2sim/simulator/zerg_methods"
    autoload :TerranMethods,  "sc2sim/simulator/terran_methods"
    autoload :ProtossMethods, "sc2sim/simulator/protoss_methods"

    attr_reader :supply, :actions, :workers, :time, :minerals, :gas
    attr_writer :minerals, :gas
    alias supplies supply
    alias vespene gas

    def initialize(race)
      @time = 0.seconds
      @supply = SC2::SupplyRatio.new(self)
      @actions = SC2::ActionQueue.new
      @minerals = 50
      @gas = 0

      set_race(race)
      init_workers
      init_race if respond_to?(:init_race)
    end

    def build(unit_or_structure, options = {})
      everything.each do |object|
        if object.can_produce?(unit_or_structure)
          return object.produce(self, unit_or_structure)
        end
      end
      raise ArgumentError, "Couldn't find any suitable candidate to build #{unit_or_structure.inspect}"
    end
    
    def add_action(type, unit_or_structure)
      actions.push(SC2::Actions.const_get(type).new(self, unit_or_structure)).last
    end
    
    # Pays for a given object. Reduces minerals and gas by the object's mineral and gas cost, and raises
    # SC2::Errors::SupplyLimitReached if the object requires more supplies than are available.
    #
    # Note that this method does not actually add the object to #structures or #units.
    def pay_for(game_object)
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
      
      # how long should we wait?
      min_per_second = income_per_second(:minerals)
      gas_per_second = income_per_second(:gas)
      min_remaining = min_per_second != 0 && min_remaining / min_per_second
      gas_remaining = gas_per_second != 0 && gas_remaining / gas_per_second

      seconds_remaining = min_remaining && gas_remaining ? [min_remaining, gas_remaining].max : min_remaining || gas_remaining
      if seconds_remaining && seconds_remaining > 0
        wait(seconds_remaining)
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
    def wait(seconds)
      @time += seconds
      @minerals += workers.minerals(seconds)
      @gas += workers.gas(seconds)
      evaluate_action_queue
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
#      type ? actions.completed_structures.select { |c| c.kind_of?(type) } : actions.completed_structures
    end

    # Returns all units built up to the current moment in game time. Note that units that
    # are still under construction are omitted.
    def units
      workers + army
    end
    
    def army
      @army ||= []
    end

    private
    # Checks the first item in the action queue and sees if the action can be performed
    # right now; if so, the action is processed and removed from the queue, and the next
    # action is evaluated. Actions are evaluated linearly: that is, if the first action
    # in the queue cannot be processed, none of them are.
    def evaluate_action_queue
      return if actions.empty?
      if actions.first.completed?
        target = actions.shift.target
        case target
          when SC2::Structures::Base then structures.push(target)
          when SC2::Units::Worker    then workers.push(target)
          when SC2::Units::Base      then army.push(target)
          else raise ArgumentError, "Expected target to be a structure, worker unit or army unit. Got: #{target.inspect}"
        end
        evaluate_action_queue
      end
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