class SC2::Structures::Extractor < SC2::Structures::GasSource
  handle :extractor
  costs 25

  def mineral_type
    :gas
  end
end
