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
  
  context "with supplies built before supply blocking" do
    before(:each) { subject.build(:overlord); 12.times { subject.build(:drone) } }
    
    it "should not allow building more drones" do
      proc { subject.build(:drone) }.should raise_error(SC2::Errors::SupplyLimitReached)
    end
    
    it "should allow building drones only after building supplies" do
      proc do
        subject.build(:overlord)
        subject.build(:drone)
      end.should_not raise_error
    end
  end
  
  context "with population max being built, but not yet built" do
    before(:each) do
      4.times { subject.build(:drone) }
    end
    
    it "should have no supply remaining" do
      subject.supply.remaining.should == 0
    end
    
    it "should not allow building more drones" do
      proc { subject.build(:drone) }.should raise_error(SC2::Errors::SupplyLimitReached)
    end
    
    context "with supplies on the way" do
      before(:each) { subject.build(:overlord) }
      
      it "should wait for supplies" do
        proc { subject.build(:drone) }.should_not raise_error
      end
      
      it "should consume supplies" do
        subject.build(:drone)
        subject.supplies.consumed.should == 11
      end
    end
  end
  
  context "with maxed-out population" do
    before(:each) do
      4.times { subject.build(:drone).and_wait }
    end
    
    it "should have no supply remaining" do
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
