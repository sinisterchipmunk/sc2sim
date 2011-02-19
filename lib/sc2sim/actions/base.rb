class SC2::Actions::Base
  include SC2::Inspection
  attr_reader :simulator, :started_at, :completed_at
  omits :simulator
  
  def initialize(game, duration)
    @simulator = game

    @started_at = simulator.time
    @completed_at = simulator.time + duration
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
  
  def trigger!
    raise ArgumentError, "Expected subclass to override #trigger! but apparently that didn't happen"
  end
end