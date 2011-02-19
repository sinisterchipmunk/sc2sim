module SC2::Errors
  # Base error extended by all SC2sim errors.
  class ::SC2::Errors::StandardError < ::StandardError
  end
  
  # Raised when workers are sent to gather gas with no extractor, assimilator or refinery.
  class MissingExtractor < SC2::Errors::StandardError
  end

  # Raised when something must be built but the supply limit has already been reached.
  class SupplyLimitReached < SC2::Errors::StandardError
  end
  
  # Raised when asked to wait for more supply, but nothing in the action queue will add to supply.
  class SupplyUnavailable < SC2::Errors::StandardError
  end
  
  # Raised when an action is expected to be in the action queue, but it is not.
  class NotInQueue < SC2::Errors::StandardError
  end
  
  # Raised when attempting to force a unit to cast a spell that it doesn't know.
  class MissingSpell < SC2::Errors::StandardError
  end

  # Raised when attempting to cast a spell without the appropriate spellcaster.
  class MissingSpellcaster < SC2::Errors::StandardError
  end
end
