class SC2::Actions::Construction
  include SC2::Inspection
  include SC2::MetaData
  attr_reader :simulator, :target, :started_at, :completed_at
  omits :simulator

  def initialize(game, what_to_build)
    @simulator = game
    @target = lookup_game_object(what_to_build)

    simulator.wait_until_affordable(target)
    simulator.pay_for(target)
    
    @started_at = simulator.time
    @completed_at = simulator.time + target.build_time
  end

  def instantly!
    @completed_at = @started_at
    simulator.wait(0) # force to process the action queue
  end

  def completed?
    simulator.time >= @completed_at
  end

  def and_wait
    simulator.wait(@completed_at - simulator.time)
  end

  private
  def lookup_game_object(what_to_build)
    SC2::GameObject.registry.each do |handle, type|
      if handle == what_to_build || type == what_to_build
        return type.new
      end
    end
    raise ArgumentError, "Expected build type to be one of #{SC2::GameObject.registry.keys.inspect}"
  end
end
