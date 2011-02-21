class SC2::Actions::Construction < SC2::Actions::Base
  include SC2::MetaData
  attr_reader :target
  
  def inspect
    "#<#{target.class.base_name} @ #{started_at.inspect} until #{completed_at.inspect}>"
  end

  def initialize(game, what_to_build)
    @target = lookup_game_object(what_to_build)
    game.wait_until_affordable(target)
    game.pay_for(target)
    
    super(game, target.build_time)
  end

  def trigger!
    case target
      when SC2::Structures::Base then @simulator.structures.push(target)
      when SC2::Units::Worker    then @simulator.workers.push(target)
      when SC2::Units::Base      then @simulator.army.push(target)
      else raise ArgumentError, "Expected target to be a structure, worker unit or army unit. Got: #{target.inspect}"
    end
  end
  
  def handle
    target.handle
  end

  private
  def lookup_game_object(what_to_build)
    SC2::GameObject.registry.each do |handle, type|
      if handle == what_to_build || type == what_to_build
        return type.new
      end
    end
    raise ArgumentError, "Expected build type to be one of #{SC2::GameObject.registry.keys.inspect}, received #{what_to_build.inspect}"
  end
end
