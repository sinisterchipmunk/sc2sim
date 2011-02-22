# This module holds various meta data regarding SC2 game mechanics. Most of this is related to timing,
# e.g., average rate of income per second, etc.
#
# Sources:
#   http://sc2armory.com/forums/topic/10550
#   http://sc2math.com/
#   http://www.teamliquid.net/forum/viewmessage.php?topic_id=140055
#   http://wiki.teamliquid.net/starcraft2/Mining
#
class SC2::Data
  # TODO use separate income rates, 2 workers/3 workers per cluster/geyser.
  
  # Average mineral income per worker per second; defaults to 0.6666 (40 min per minute)
  # Note that this isn't entirely accurate, as the 3rd worker on any given patch will only
  # mine 20 min per minute.
  #
  attr_accessor :mineral_rate
  
  # Average gas income per worker per second; defaults to 0.6333 (38 gas per minute)
  attr_accessor :gas_rate
  
  # Maximum larvae per hatchery; defaults to 19
  attr_accessor :max_larvae_per_hatchery
  
  # Refund percentage when cancelling construction. Defaults to 0.75.
  attr_accessor :refund_percentage
  
  def initialize
    @mineral_rate = 0.666666
    @gas_rate = 0.633333
    @max_larvae_per_hatchery = 19
    @refund_percentage = 0.75
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