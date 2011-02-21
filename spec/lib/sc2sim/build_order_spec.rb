# Build order is a wrapper around SC2::Simulator that provides
# a higher-level interface. This way you can specify traditional
# build orders instead of a step-by-step set of directions.
require 'spec_helper'

describe SC2::BuildOrder do
  subject { SC2::BuildOrder.new(:zerg) }
  
  it "should auto-drone on number" do
    subject.at 9, :overlord
    
    subject.wait_for :everything
    subject.drones.count.should == 9
  end
  
  it "should auto-drone on supply" do
    subject.at 9.supply, :overlord
    
    subject.wait_for :everything
    subject.drones.count.should == 9
  end
  
  it "should raise when no miners are available" do
    subject.drones.stop_gathering
    proc { subject.at 200.minerals, :overlord }.should raise_error(SC2::Errors::ImpossibleCondition)
  end
  
  it "should mine enough" do
    subject.at 200.minerals, :overlord
    subject.minerals.should be > 100  
    subject.minerals.should be < 200  
  end
  
  it "should raise when no gas gatherers are available" do
    proc { subject.at 200.gas, :overlord }.should raise_error(SC2::Errors::ImpossibleCondition)
  end
  
  it "should gas enough" do
    subject.build :extractor
    subject.gather_gas
    
    subject.at 200.gas, :overlord
    subject.gas.should be >= 200
  end
  
  it "should raise when waiting for something that isn't being built" do
    proc { subject.at 75.percent(:queen), :overlord }.should raise_error(SC2::Errors::ImpossibleCondition)
  end
  
  it "should trigger at percentages" do
    subject.build :overlord
    start = subject.time
    subject.at 15.percent(:overlord), nil
    subject.time.should == start + (SC2::Units::Overlord.build_time * 0.15).to_i.seconds
  end
  
  it "should wait for special stuff" do
    subject.build :overlord
    subject.overlords.count.should == 0
    subject.at :overlord, :drone
    subject.overlords.count.should == 1
  end
end
