# Describes behavior regarding spellcasters, specifically, energy consumption and regeneration.
require 'spec_helper'

describe SC2::Units::Spellcaster do
  subject do
    sim = SC2::Simulator.new(:zerg)
    sim.build(:queen).and_wait
    sim
  end
  
  it "should have starting energy" do
    subject.queens.first.energy.should == 25
  end
  
  it "should regenerate energy" do
    subject.wait(10.seconds)
    subject.queens.first.energy.should be > 25
  end
  
  it "should max out energy" do
    subject.wait(500.seconds)
    subject.queens.first.energy.should == 200
  end
  
  context "when casting spells" do
    before(:each) { subject.cast(:spawn_larvae) }
    
    it "should use energy" do
      subject.queens.first.energy.should == 0
    end
    
    it "should trigger spell" do
      subject.actions.first.should be_kind_of(SC2::Actions::Spell)
    end
    
    it "should incubate for 40 seconds" do
      subject.units(SC2::Units::Larva).count.should == 3
      subject.wait(40.seconds)
      subject.units(SC2::Units::Larva).count.should == 7
    end
  end
end
