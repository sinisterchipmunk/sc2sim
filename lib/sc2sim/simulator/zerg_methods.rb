module SC2::Simulator::ZergMethods
  def init_race
    structures.push SC2::Structures::Hatchery.new
    3.times { army.push(SC2::Units::Larva.new) }
  end

  def drones
    workers
  end
  
  def larvae
    army.select { |a| a.kind_of?(SC2::Units::Larva) }
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
