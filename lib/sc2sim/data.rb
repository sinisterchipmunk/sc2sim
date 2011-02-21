# This module holds various meta data regarding SC2 game mechanics. Most of this is related to timing,
# e.g., average rate of income per second, etc.
#
# Sources:
#   http://sc2armory.com/forums/topic/10550
#   http://sc2math.com/
#   http://www.teamliquid.net/forum/viewmessage.php?topic_id=140055
#
class SC2::Data
  # TODO use 3 separate income rates, for 1 worker/2 workers/3 workers per cluster/geyser.
  
  # Average mineral income per worker per second; defaults to 1.1867 (average of 0.6074, 1.2148, 1.7381)
  attr_accessor :mineral_rate
  
  # Average gas income per worker per second; defaults to 1.225 (average of 0.625, 1.2583, 1.7916)
  attr_accessor :gas_rate
  
  # Maximum larvae per hatchery; defaults to 19
  attr_accessor :max_larvae_per_hatchery
  
  def initialize
    @mineral_rate = 1.1867
    @gas_rate = 1.225
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