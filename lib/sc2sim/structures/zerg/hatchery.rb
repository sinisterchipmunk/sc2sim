class SC2::Structures::Hatchery < SC2::Structures::Base
  handle :hatchery
  supplies 10
  costs 300
  build_time 100.seconds
  produces :larva
  
  every 14.seconds do
    army.push(SC2::Units::Larva.new) unless larvae.count >= hatcheries.count * 3
  end
end
