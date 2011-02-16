# Tests behavior when building structures.
require 'spec_helper'

describe "Structure construction" do
  subject { SC2::Simulator.new(:zerg) }
  
  it "should be placed into the structures array upon completion" do
    subject.build(:hatchery).and_wait
    subject.hatcheries.count.should == 2
  end
end
