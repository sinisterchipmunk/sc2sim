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
end
