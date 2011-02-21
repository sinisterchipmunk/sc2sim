class SC2::Units::Worker < SC2::Units::Base
  costs 50, 0, 1

  def gather(what)
    stop_gathering
    
    if what.respond_to?(:mineral_type) && what.mineral_type == :gas
      @gathering = what
      @gathering.workers.push(self)
    elsif what.kind_of?(SC2::Actions::Base) && what.target.respond_to?(:mineral_type) && what.target.mineral_type == :gas
      @gathering = what
      @gathering.target.workers.push(self)
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
      when SC2::Actions::Base
        @gathering.target.workers.delete(self)
    end
    @gathering = nil
  end
  
  def gather_source
    @gathering = @gathering.target if @gathering.respond_to?(:completed?) && @gathering.completed?
    @gathering
  end

  def gathering?(what = nil)
    case what
      when :minerals
        gather_source == :minerals
      when :gas
        gather_source == :gas || (gather_source.respond_to?(:mineral_type) && gather_source.mineral_type == :gas)
      when nil
        !!gather_source
      else
        false
    end
  end
end
