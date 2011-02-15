class SC2::Units::Worker < SC2::Units::Base
  costs 50, 0, 1

  def gather(what)
    stop_gathering
    
    if what.respond_to?(:mineral_type) && what.mineral_type == :gas
      @gathering = what
      @gathering.workers.push(self)
    else
      case what
        when :minerals
          @gathering = what
        when :gas
          raise SC2::Errors::MissingExtractor, "You must specify which extractor, assimilator or refinery to use."
        else
          raise ArgumentError, "Expected argument to be either :minerals, or an extractor, assimilator or refinery."
      end
    end
  end
  
  def stop_gathering
    case @gathering
      when SC2::Structures::GasSource
        @gathering.workers.delete(self)
    end
    @gathering = nil
  end
  
  def gather_source
    @gathering
  end

  def gathering?(what = nil)
    case what
      when :minerals
        @gathering == :minerals
      when :gas
        @gathering == :gas || (@gathering.respond_to?(:mineral_type) && @gathering.mineral_type == :gas)
      when nil
        !!@gathering
      else
        false
    end
  end
end
