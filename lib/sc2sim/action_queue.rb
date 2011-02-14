class SC2::ActionQueue < Array
  # returns all Construction actions which were responsible for creating structures and which have already completed.
  def completed_structures
    select.select do |action|
      action.kind_of?(SC2::Actions::Construction) && action.target.kind_of?(SC2::Structures::Base) && action.completed?
    end.collect do |action|
      action.target
    end
  end
end
