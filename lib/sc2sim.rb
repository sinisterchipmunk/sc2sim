require "active_support/core_ext"

$:.unshift(File.dirname(__FILE__))
require File.join(File.dirname(__FILE__), "core_ext/fixnum")

module SC2
  autoload :BuildOrder, "sc2sim/build_order"
  autoload :Adjectives, "sc2sim/adjectives"
  autoload :Inspection, "sc2sim/inspection"
  autoload :VERSION, "sc2sim/version"
  autoload :Simulator, "sc2sim/simulator"
  autoload :WorkerSet, "sc2sim/worker_set"
  autoload :SupplyRatio, "sc2sim/supply_ratio"
  autoload :GameObject, "sc2sim/game_object"
  autoload :Structures, "sc2sim/structures"
  autoload :Units, "sc2sim/units"
  autoload :Actions, "sc2sim/actions"
  autoload :ActionQueue, "sc2sim/action_queue"
  autoload :Errors, "sc2sim/errors"
  autoload :Data, "sc2sim/data"
  autoload :MetaData, "sc2sim/data"
  autoload :Upgrades, "sc2sim/upgrades"
  
  def self.data
    @data ||= SC2::Data.new
  end
end

# eager load the units and structures
Dir[File.join(File.dirname(__FILE__), "sc2sim/structures/zerg/**/*.rb")].each { |fi| require fi }
Dir[File.join(File.dirname(__FILE__), "sc2sim/units/zerg/**/*.rb")].each { |fi| require fi }
Dir[File.join(File.dirname(__FILE__), "sc2sim/upgrades/zerg/**/*.rb")].each { |fi| require fi }

Dir[File.join(File.dirname(__FILE__), "sc2sim/structures/terran/**/*.rb")].each { |fi| require fi }
Dir[File.join(File.dirname(__FILE__), "sc2sim/units/terran/**/*.rb")].each { |fi| require fi }
Dir[File.join(File.dirname(__FILE__), "sc2sim/upgrades/terran/**/*.rb")].each { |fi| require fi }

Dir[File.join(File.dirname(__FILE__), "sc2sim/structures/protoss/**/*.rb")].each { |fi| require fi }
Dir[File.join(File.dirname(__FILE__), "sc2sim/units/protoss/**/*.rb")].each { |fi| require fi }
Dir[File.join(File.dirname(__FILE__), "sc2sim/upgrades/protoss/**/*.rb")].each { |fi| require fi }
