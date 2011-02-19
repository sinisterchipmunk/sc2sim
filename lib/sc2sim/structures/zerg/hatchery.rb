class SC2::Structures::Hatchery < SC2::Structures::Base
  handle :hatchery
  supplies 10
  costs 300
  build_time 100.seconds
  produces :queen
#  produces :larva
  
  every 15.seconds do
    # we can't just build(:larva) because that sticks it in the action queue. Larvae spawn
    # passively so we should bypass "actions" if for no other reason than the implications.
    army.push(SC2::Units::Larva.new) unless larvae.count >= hatcheries.count * 3
  end
end
