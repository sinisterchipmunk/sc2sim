class SC2::Actions::Spell < SC2::Actions::Base
  # Options include:
  #   cost - amount of energy expended to cast spell
  #   incubation - number of seconds between spell cast and spell effect
  #   block - block to be called to create spell effect
  #
  def initialize(game, name_of_spell, options)
    @name = name_of_spell
    @options = options
    
    super(game, options[:incubation] || 0, self)
  end
  
  def trigger!
    @options[:block].call(simulator)
  end
  
  def handle
    @name
  end
end
