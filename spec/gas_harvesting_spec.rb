# Tests behavior regarding gas harvesting
require 'spec_helper'

describe "Gas harvesting" do
  subject { SC2::Simulator.new(:zerg) }
  
  context "with no extractors" do
    it "should not allow harvesting" do
      proc { subject.drones[0..3].gather(:gas) }.should raise_error(SC2::Errors::MissingExtractor)
    end
  end
  
  context "with 1 extractor" do
    before(:each) { subject.build(:extractor).and_wait }

    context "with no drones" do
      it "should have no gas income over 10 seconds" do
        subject.wait(10.seconds)
        subject.gas.should == 0
      end
    end
    
    context "with 1 drone" do
      before(:each) { subject.drones[0].gather(subject.extractors.last) }
      
      it "should not exceed 20 gas income over 10 seconds" do
        subject.wait(10.seconds)
        subject.gas.should == 12.249999999999998
      end
    end

    context "with 2 drones" do
      before(:each) { subject.drones[0..1].gather(subject.extractors.last) }
      
      it "should not exceed 40 gas income over 10 seconds" do
        subject.wait(10.seconds)
        subject.gas.should == 24.499999999999996
      end
    end

    context "with 3 drones" do
      before(:each) { subject.drones[0..2].gather(subject.extractors.last) }
      
      it "should not exceed 60 gas income over 10 seconds" do
        subject.wait(10.seconds)
        subject.gas.should == 36.75
      end
    end

    context "with too many drones" do
      before(:each) { subject.drones.gather(subject.extractors.last) }
      
      it "should not exceed 60 gas income over 10 seconds" do
        subject.wait(10.seconds)
        subject.gas.should == 36.75
      end
    end
  end
end
