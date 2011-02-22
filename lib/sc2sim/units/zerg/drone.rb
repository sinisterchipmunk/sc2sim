class SC2::Units::Drone < SC2::Units::Worker
  handle :drone
  
  produces :extractor, :hatchery, :spawning_pool, :evolution_chamber, :spine_crawler, :spore_crawler,
           :hydralisk_den, :baneling_nest, :roach_warren, :infestation_pit, :spire, :nydus_network,
           :ultralisk_cavern

  build_time 17.seconds
  
  def initialize
    super()
    gather(:minerals)
  end
  
  def cancel(action)
    action.simulator.workers.push(self)
    super
  end

  def produce(game, unit_or_structure)
    # Zerg construction consumes the drone that started it
    game.workers.delete(self)
    super
  end
end
