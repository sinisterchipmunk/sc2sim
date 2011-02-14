# Base class representing every object in the game. Contributes generic methods which could apply to both buildings
# and units.
class SC2::GameObject
  @@registry = {}

  def supply_consumed
    0
  end

  def supply_produced
    0
  end

  def mineral_cost
    0
  end

  def gas_cost
    0
  end

  class << self
    def base_name
      name.split('::').last || ''
    end

    def costs(minerals, gas = 0, supply = 0)
      define_method(:supply_consumed) { supply }
      define_method(:mineral_cost) { minerals }
      define_method(:gas_cost) { gas }
    end

    def produces(supply)
      define_method(:supply_produced) { supply }
    end

    def handle(symbol)
      registry[symbol] = self
    end

    def registry
      @@registry
    end
  end
end