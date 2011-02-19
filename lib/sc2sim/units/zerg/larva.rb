class SC2::Units::Larva < SC2::Units::Base
  costs 0, 0, 0
  handle :larva
  produces :drone, :overlord, :zergling, :roach, :hydralisk, :mutalisk, :corruptor, :infestor, :ultralisk
#  produces :zergling,  :with => :spawning_pool
#  produces :roach,     :with => :roach_warren
#  produces :hydralisk, :with => :hydralisk_den
#  produces :mutalisk,  :with => :spire
#  produces :corruptor, :with => :spire
#  produces :infestor,  :with => :infestation_pit
#  produces :ultralisk, :with => :ultralisk_cavern
  
  def produce(game, unit_or_structure)
    # producing a Zerg unit consumes the larva
    game.army.delete(self)
    super
  end
end
