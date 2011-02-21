module SC2::Simulator::ZergMethods
  def init_race
    structures.push SC2::Structures::Hatchery.new
    3.times { army.push(SC2::Units::Larva.new) }
  end

  def drones
    workers
  end
  
  def larvae
    army(SC2::Units::Larva)
  end

  def hatcheries
    structures(SC2::Structures::Hatchery)
  end

  def extractors
    structures(SC2::Structures::Extractor) + actions.select { |c| c.target.kind_of?(SC2::Structures::Extractor) }
  end
  
  def overlords
    army(SC2::Units::Overlord)
  end

  def worker_type
    SC2::Units::Drone
  end
  
  def queens
    units(SC2::Units::Queen)
  end
end
