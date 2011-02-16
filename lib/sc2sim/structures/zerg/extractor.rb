class SC2::Structures::Extractor < SC2::Structures::GasSource
  handle :extractor
  costs 25
  build_time 30.seconds

  def mineral_type
    :gas
  end
end
