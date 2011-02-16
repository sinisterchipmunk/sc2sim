class SC2::Structures::Hatchery < SC2::Structures::Base
  handle :hatchery
  supplies 10
  build_time 100.seconds
  produces :drone
end
