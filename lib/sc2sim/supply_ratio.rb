class SC2::SupplyRatio
  def initialize(simulator)
    @simulator = simulator
  end

  def available
    @simulator.everything.inject(0) { |qty, object| qty + object.supply_produced }
  end

  def consumed
    @simulator.everything.inject(0) { |qty, object| qty + object.supply_consumed }
  end

  def remaining
    available - consumed
  end

  alias used consumed
end
