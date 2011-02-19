class SC2::Units::Queen < SC2::Units::Spellcaster
  handle :queen
  costs 150, 0, 2
  build_time 50.seconds
  starting_energy 25
  max_energy 200
  energy_regeneration_rate 0.56
  
  casts :spawn_larvae, :cost => 25, :incubation => 40.seconds do |game|
    4.times do
      unless game.army(SC2::Units::Larva).count > SC2.data.max_larvae_per_hatchery * game.hatcheries.count
        game.army.push(SC2::Units::Larva.new)
      end
    end
  end
end
