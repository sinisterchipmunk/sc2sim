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
  
  def stop_gathering(what = nil)
    case @gathering
      when SC2::Structures::GasSource
        if what == :gas || what == @gathering || what.nil?
          @gathering.workers.delete(self)
          @gathering = nil
        end
      when SC2::Actions::Base
        if what == :gas || what == @gathering || what.nil?
          @gathering.target.workers.delete(self)
          @gathering = nil
        end
      when :minerals
        if what == :minerals || what.nil?
          @gathering = nil
        end
    end
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
