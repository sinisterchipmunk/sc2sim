require "active_support/core_ext"

module SC2
  class Simulator
    autoload :ZergMethods,    "sc2sim/simulator/zerg_methods"
    autoload :TerranMethods,  "sc2sim/simulator/terran_methods"
    autoload :ProtossMethods, "sc2sim/simulator/protoss_methods"

    attr_reader :supply, :action_queue, :workers, :time, :minerals, :gas
    alias vespene gas

    def initialize(race)
      @time = 0.seconds
      @supply = SC2::SupplyRatio.new(self)
      @action_queue = SC2::ActionQueue.new
      @minerals = 50
      @gas = 0

      set_race(race)
      init_workers
      init_race if respond_to?(:init_race)
    end

    def build(unit_or_structure)
      action_queue.push(SC2::Actions::Construction.new(self, unit_or_structure)).last
    end

    # Waits until the specified object is affordable based on its mineral and vespene costs.
    def wait_until_affordable(object)
      # how long should we wait?
      min_per_second = income_per_second(:minerals)
      gas_per_second = income_per_second(:gas)
      min_remaining = min_per_second != 0 && object.mineral_cost / min_per_second
      gas_remaining = gas_per_second != 0 && object.gas_cost     / gas_per_second

      seconds_remaining = min_remaining && gas_remaining ? [min_remaining, gas_remaining].max : min_remaining || gas_remaining
      if seconds_remaining && seconds_remaining > 0
        wait(seconds_remaining)
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
      type ? action_queue.completed_structures.select { |c| c.kind_of?(type) } : action_queue.completed_structures
    end

    # Returns all units built up to the current moment in game time. Note that units that
    # are still under construction are omitted.
    def units
      # FIXME stub
      workers + []
    end

    private
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