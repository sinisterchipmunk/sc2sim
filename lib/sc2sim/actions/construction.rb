class SC2::Actions::Construction < SC2::Actions::Base
  include SC2::MetaData
  attr_reader :target
  
  def inspect
    "#<#{target.class.base_name} @ #{started_at.inspect} until #{completed_at.inspect}>"
  end

  def initialize(game, what_to_build, producer)
    @target = lookup_game_object(what_to_build)
    @producer = producer
    game.wait_until_affordable(target)
    game.pay_for(target)
    
    super(game, target.build_time, producer)
  end

  def trigger!
    case target
      when SC2::Structures::Base then @simulator.structures.push(target)
      when SC2::Units::Worker    then @simulator.workers.push(target)
      when SC2::Units::Base      then @simulator.army.push(target)
      when SC2::Upgrades::Base   then @simulator.upgrades.push(target)
      else raise ArgumentError, "Expected target to be a structure, upgrade, worker unit or army unit. Got: #{target.inspect}"
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
