require "spec_helper"

describe SC2::Actions::Construction do
  subject { SC2::Simulator.new(:zerg).build(:hatchery) }

  it "should add the building to the action queue" do
    subject.simulator.actions.should_not be_empty
  end

  it "should not add the building to the structures array" do
    # we skew the count by 1 because simulator starts with a building. We're testing internals here
    # which is bad, but I don't know a better way. TODO make this better or remove it entirely
    subject.simulator.structures.count.should be < subject.simulator.actions.count+1
  end

  context "created instantly" do
    before(:each) { subject.instantly! }

    it "should add the building to the structures array" do
      subject.simulator.structures.should_not be_empty
    end
  end
end
