require 'spec_helper'

describe SC2::GameObject do
  context "defaults" do
    it "should have 0 supply consumed" do
      subject.supply_consumed.should == 0
    end
    
    it "should have 0 supply produced" do
      subject.supply_produced.should == 0
    end
    
    it "should have 0 supplies consumed" do
      subject.supplies_consumed.should == 0
    end
    
    it "should have 0 supplies produced" do
      subject.supplies_produced.should == 0
    end
    
    it "should have 0 gas cost" do
      subject.gas_cost.should == 0
    end
    
    it "should have 0 mineral cost" do
      subject.mineral_cost.should == 0
    end
    
    it "should have 0 build time" do
      subject.build_time.should == 0.seconds
    end
  end
end