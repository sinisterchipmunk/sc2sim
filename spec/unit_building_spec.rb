# Tests behavior when building units.
require 'spec_helper'

describe "Unit construction" do
  subject { SC2::Simulator.new(:zerg) }
  
  context "larva spawning over time" do
    it "should not exceed 3 for 1 hatchery" do
      subject.wait(100.seconds)
      subject.larvae.count.should == 3
    end
    
    it "should not exceed 6 for 2 hatcheries" do
      subject.build(:hatchery).and_wait
      subject.wait(100.seconds)
      subject.larvae.count.should == 6
    end
  end
  
  context "with maxed-out population" do
    before(:each) do
      4.times { subject.build(:drone).and_wait }
      subject.supply.remaining.should == 0
    end
    
    it "should not allow building more drones" do
      proc { subject.build(:drone) }.should raise_error(SC2::Errors::SupplyLimitReached)
    end
    
    it "should gather minerals by default" do
      subject.drones.each { |drone| drone.should be_gathering(:minerals) }
    end
  end
end
