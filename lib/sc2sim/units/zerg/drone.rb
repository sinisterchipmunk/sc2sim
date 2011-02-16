class SC2::Units::Drone < SC2::Units::Worker
  handle :drone
  produces :extractor, :hatchery
  
  def initialize
    super()
    gather(:minerals)
  end
end
