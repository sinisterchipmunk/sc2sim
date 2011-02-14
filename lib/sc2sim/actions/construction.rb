class SC2::Actions::Construction
  attr_reader :simulator, :target

  def initialize(game, what_to_build)
    @simulator = game
    @target = game.action_queue.push(lookup_game_object(what_to_build)).last

    simulator.wait_until_affordable(target)
    @started_at = simulator.time
    @completed_at = simulator.time + 30.seconds
  end

  def instantly!
    @completed_at = @started_at
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
