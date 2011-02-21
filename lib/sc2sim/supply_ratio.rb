class SC2::SupplyRatio
  def initialize(simulator)
    @simulator = simulator
  end

  def available
    @simulator.everything.inject(0) { |qty, object| qty + object.supply_produced }
  end

  def consumed
    @simulator.everything.inject(0) { |qty, object| qty + object.supply_consumed } + pending_supply_consumption
  end
  
  def pending_supply_consumption                                                                               
    @simulator.actions.inject(0) { |qty, action| qty + (action.respond_to?(:target) ? action.target.supply_consumed : 0) }
  end

  def remaining
    available - consumed
  end

  def inspect
    "#<SC2::SupplyRatio [#{consumed}/#{available}]>"
  end
  
  def available?
    remaining > 0
  end

  alias used consumed
end
