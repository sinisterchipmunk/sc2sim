# Behavior spec dealing with Zerg-specific objects and mechanics
require 'spec_helper'

describe "Zerg mechanics" do
  subject { SC2::Simulator.new(:zerg) }
  
  context "with a spawning pool" do
    before(:each) { subject.build(:spawning_pool) }

    it "should build zerglings" do
      proc { subject.build(:zerglings) }.should_not raise_error
    end
  end
end