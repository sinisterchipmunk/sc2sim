module SC2::Structures
  class GasSource < SC2::Structures::Base
    def income_per_second
      case workers.count
        when 0 then 0
        when 1 then gas_rate
        when 2 then gas_rate*2
        else gas_rate*3 # more than 3 workers to a geyser is superfluous
      end
    end
    
    def workers
      @workers ||= []
    end
  end
end
