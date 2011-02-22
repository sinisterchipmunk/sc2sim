class SC2::Structures::SpawningPool < SC2::Structures::Base
  handle :spawning_pool
  costs 200, 0, 0
  build_time 65.seconds
  
  produces :metabolic_boost
end
