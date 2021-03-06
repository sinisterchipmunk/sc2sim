# Base class representing every object in the game. Contributes generic methods which could apply to both buildings
# and units.
class SC2::GameObject
  include SC2::MetaData
  @@registry = {}

  def inspect
    ivars = ""
    instance_variables.each { |ivar|
      next if [:"@workers"].include? ivar
      ivars = "#{ivars} #{ivar}=#{instance_variable_get(ivar).inspect}"
    }
    "#<#{self.class.base_name}#{ivars}>"
  end

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
    game.add_action :Construction, unit_or_structure, self
  end
  
  def cancel(action)
    action.simulator.actions.delete action
    action.simulator.minerals += action.target.class.mineral_cost * SC2.data.refund_percentage
    action.simulator.gas      += action.target.class.gas_cost     * SC2.data.refund_percentage
  end

  class << self
    def base_name
      name.split('::').last || ''
    end
    
    def every(how_often, &block)
      SC2::Simulator.every(how_often, &block)
    end

    def costs(minerals, gas = 0, supply = 0)
      @costs = { :minerals => minerals, :gas => gas, :supply => supply }
      define_method(:supply_consumed) { supply   }
      define_method(:mineral_cost)    { minerals }
      define_method(:gas_cost)        { gas      }
    end
    
    def supply_consumed
      (@costs || {})[:supply]
    end
    
    def mineral_cost
      (@costs || {})[:minerals]
    end
    
    def gas_cost
      (@costs || {})[:gas]
    end
    
    def build_time(time = nil)
      if time
        @build_time = time
        define_method(:build_time) { time }
      end
      @build_time
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
