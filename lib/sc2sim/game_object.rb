# Base class representing every object in the game. Contributes generic methods which could apply to both buildings
# and units.
class SC2::GameObject
  include SC2::MetaData
  @@registry = {}

  def supply_consumed
    0
  end

  def supply_produced
    0
  end
  
  def supplies_consumed
    supply_consumed
  end
  
  def supplies_produced
    supply_produced
  end
  
  def build_time
    0
  end

  def mineral_cost
    0
  end

  def gas_cost
    0
  end
  
  def handle
    self.class.handle
  end
  
  def can_produce?(unit_or_structure)
    self.class.objects_produced.include? unit_or_structure
  end
  
  def produce(game, unit_or_structure)
    game.add_action :Construction, unit_or_structure
  end

  class << self
    def base_name
      name.split('::').last || ''
    end
    
    def every(how_often, &block)
      SC2::Simulator.every(how_often, &block)
    end

    def costs(minerals, gas = 0, supply = 0)
      define_method(:supply_consumed) { supply   }
      define_method(:mineral_cost)    { minerals }
      define_method(:gas_cost)        { gas      }
    end
    
    def build_time(time)
      define_method(:build_time) { time }
    end
    
    def objects_produced
      @objects_produced ||= []
    end
    
    def produces(*what)
      objects_produced.push(what)
      objects_produced.flatten!
    end

    def supplies(supply)
      define_method(:supply_produced) { supply }
    end

    def handle(symbol = nil)
      if symbol
        @handle = symbol
        registry[symbol] = self
      end
      @handle
    end

    def registry
      @@registry
    end
  end
end
