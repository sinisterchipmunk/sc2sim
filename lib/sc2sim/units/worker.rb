class SC2::Units::Worker < SC2::Units::Base
  costs 50, 0, 1

  def gather(what)
    if what.respond_to?(:mineral_type)
      gather(what.mineral_type)
    else
      @gathering = what
    end
  end

  def gathering?(what = nil)
    what ? @gathering == what : !!@gathering
  end
end
