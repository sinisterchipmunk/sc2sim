# Tests behavior when building units.
require 'spec_helper'

describe "Unit construction" do
  subject { SC2::Simulator.new(:zerg) }
  
  context "with maxed-out population" do
    before(:each) do
      4.times { subject.build(:drone).and_wait }
      subject.supply.remaining.should == 0
    end
    
    it "should not allow building more drones" do
      proc { subject.build(:drone) }.should raise_error(SC2::Errors::SupplyLimitReached)
    end
  end
end
