class SC2::Units::Spellcaster < SC2::Units::Base
  def cast(game, name_of_spell)
    if spells.key? name_of_spell
      self.energy -= spells[name_of_spell][:cost] || 0
      game.actions.push(SC2::Actions::Spell.new(game, name_of_spell, spells[name_of_spell]))
    else
      raise(SC2::Errors::MissingSpell, "The unit #{self.class} cannot cast the spell #{name_of_spell.inspect}")
    end
  end
  
  def spells
    self.class.spells
  end
  
  def can_cast?(name_of_spell)
    spells.keys.include?(name_of_spell)
  end
  
  def max_energy
    0
  end
  
  def starting_energy
    0
  end
  
  def energy
    @energy ||= starting_energy
  end
  
  def energy=(amount)
    @energy = amount
  end
  
  def energy_regeneration_rate
    1
  end
  
  def recharge(seconds)
    self.energy += energy_regeneration_rate * seconds
    self.energy = max_energy if energy > max_energy
    self.energy
  end
  
  class << self
    def spells
      @spells ||= {}
    end
    
    def max_energy(amount)
      define_method :max_energy do amount end
    end
    
    def starting_energy(amount)
      define_method :starting_energy do amount end
    end
    
    def energy_regeneration_rate(rate)
      define_method :energy_regeneration_rate do rate end
    end
    
    def casts(name, options = {}, &block)
      spells[name] = options.merge({ :block => block })
    end
  end
end
