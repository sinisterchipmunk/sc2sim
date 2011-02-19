# This module holds various meta data regarding SC2 game mechanics. Most of this is related to timing,
# e.g., average rate of income per second, etc.
#
# Sources:
#   http://sc2armory.com/forums/topic/10550
class SC2::Data
  # Average mineral income per worker per second; defaults to 1
  attr_accessor :mineral_rate
  
  # Average gas income per worker per second; defaults to 2
  attr_accessor :gas_rate
  
  # Maximum larvae per hatchery; defaults to 19
  attr_accessor :max_larvae_per_hatchery
  
  def initialize
    @mineral_rate = 1
    @gas_rate = 2
    @max_larvae_per_hatchery = 19
  end
end

# Delegates data methods into SC2.data. Used for convenience.
# 
# Example:
#   class X
#     include SC2::MetaData
#     def initialize
#       something = gas_rate * 5
#       # equivalent to:
#       something = SC2.data.gas_rate * 5
#     end
#   end
#
module SC2::MetaData
  def self.included(base)
    base.class_eval do
      SC2::Data.public_instance_methods.each do |method_name|
        delegate method_name, :to => "SC2.data" unless method_defined?(method_name)
      end
    end
  end
end