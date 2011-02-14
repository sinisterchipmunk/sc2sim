class SC2::Units::Drone < SC2::Units::Worker
  def initialize
    gather(:minerals)
  end
end
