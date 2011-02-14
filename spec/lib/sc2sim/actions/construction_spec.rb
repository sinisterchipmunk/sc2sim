require "spec_helper"

describe SC2::Actions::Construction do
  subject { SC2::Actions::Construction.new(SC2::Simulator.new(:zerg), :hatchery) }

  it "should add the building to the action queue" do
    subject.simulator.action_queue.should_not be_empty
  end

  it "should not add the building to the structures array" do
    subject.simulator.structures.count.should be < subject.simulator.action_queue.count
  end

  context "created instantly" do
    before(:each) { subject.instantly! }

    it "should add the building to the structures array" do
      subject.simulator.structures.should_not be_empty
    end
  end
end
