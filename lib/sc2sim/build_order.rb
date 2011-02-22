class SC2::BuildOrder
  def initialize(race, &block)
    @sim = SC2::Simulator.new(race)
    instance_eval &block if block_given?
  end
  
  def at(condition, unit_or_structure_to_build = nil, &block)
    case condition
      when Fixnum                    then drone_to(condition)
      when SC2::Adjectives::Supply   then drone_to(condition.qty)
      when SC2::Adjectives::Minerals then minerals_to(condition.qty)
      when SC2::Adjectives::Gas      then gas_to(condition.qty)
      when SC2::Adjectives::Percent  then wait_percent(condition)
      when Symbol                    then wait_for condition
      else raise ArgumentError, "Condition not understood: #{condition.inspect}"
    end

    case unit_or_structure_to_build
      when :extractor_trick then perform_extractor_trick
      when :worker_scout then workers.last.stop_gathering
      when Hash then
        if unit_or_structure_to_build.key?(:cast)
          cast unit_or_structure_to_build[:cast]
        else raise ArgumentError, "Invalid options"
        end
      when NilClass then ; #no-op
      else build unit_or_structure_to_build
    end

    instance_eval &block if block_given?
  end
  
  def perform_extractor_trick
    build :extractor
    build :drone
    cancel :extractor
  end
  
  def drone_to(qty)
    while supplies.consumed < qty
      build worker_type.handle
    end
  end
  
  # automatically delegate workers to extractors as is appropriate
  def gather_gas
    extractors.each_with_index do |extractor, index|
      if extractor.kind_of?(SC2::Actions::Base)
        @sim.wait_for(:extractor)
      end
      @sim.workers[(index*3)...((index+1)*3)].gather(extractor)
    end
  end
  
  def gas_to(qty)
    while gas < qty
      unless gathering?(:gas)
        raise SC2::Errors::ImpossibleCondition, "Waiting for gas, but no workers are gathering gas!"
      end
      
      wait 1.second
    end
  end
  
  def minerals_to(qty)
    while minerals < qty
      unless gathering?(:minerals)
        raise SC2::Errors::ImpossibleCondition, "Waiting for minerals, but no workers are mining!"
      end
      
      wait 1.second
    end
  end
  
  def wait_percent(pcnt)
    what = pcnt.of_what
    pcnt = pcnt.qty / 100.0
    
    unless action = building?(what)
      raise SC2::Errors::ImpossibleCondition, "Waiting for #{pcnt*100}% of #{what} to complete, but #{what} isn't under construction!"
    end
    
    target = action.started_at + (action.target.class.build_time * pcnt).to_i.seconds
    wait((target - time).seconds)
  end
  
  def method_missing(name, *args, &block)
    @sim.respond_to?(name) ? @sim.send(name, *args, &block) : super
  end
  
  def respond_to?(name)
    super || @sim.respond_to?(name)
  end
end