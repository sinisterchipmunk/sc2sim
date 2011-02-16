class SC2::Units::Drone < SC2::Units::Worker
  handle :drone
  produces :extractor, :hatchery
  build_time 17.seconds
  
  def initialize
    super()
    gather(:minerals)
  end
end
