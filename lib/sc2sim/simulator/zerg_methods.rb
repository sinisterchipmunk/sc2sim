module SC2::Simulator::ZergMethods
  def init_race
    actions.push(SC2::Actions::Construction.new(self, :hatchery)).last.instantly!
#    build(:hatchery).instantly!
  end

  def drones
    workers
  end

  def hatcheries
    structures(SC2::Structures::Hatchery)
  end

  def extractors
    structures.select { |c| c.kind_of?(SC2::Structures::Extractor) }
  end

  def worker_type
    SC2::Units::Drone
  end
end
