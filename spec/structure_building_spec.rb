# Tests behavior when building structures.
require 'spec_helper'

describe "Structure construction" do
  subject { SC2::Simulator.new(:zerg) }
  
  it "should be placed into the structures array upon completion" do
    subject.build(:hatchery).and_wait
    subject.hatcheries.count.should == 2
  end
  
  context "cancelling" do
    it "should be cancel-able" do
      subject.build :hatchery
      subject.cancel :hatchery
    
      subject.hatcheries.count.should == 1
    end
  
    it "should raise when cancelling a missing action" do
      proc { subject.cancel :hatchery }.should raise_error(SC2::Errors::NotInQueue)
    end
    
    it "should return 75% of original cost" do
      subject.minerals = 300
      subject.build :hatchery
      subject.cancel :hatchery
      subject.minerals.should == 225
    end
  end

  it "should return the drone" do
    subject.build :hatchery
    subject.cancel :hatchery
    subject.drones.count.should == 6
  end
end
