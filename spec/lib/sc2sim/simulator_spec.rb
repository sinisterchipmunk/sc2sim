require 'spec_helper'

describe SC2::Simulator do
  context "for zerg" do
    subject { SC2::Simulator.new(:zerg) }

    it "should have 6 drones" do
      subject.drones.count.should == 6
    end

    it "should have 1 hatchery" do
      subject.hatcheries.count.should == 1
    end

    it "should have 10 supply available" do
      subject.supply.available.should == 10
    end

    it "should have 4 supply remaining" do
      subject.supply.remaining.should == 4
    end

    it "should have 6 supply consumed" do
      subject.supply.consumed.should == 6
    end

    it "should build an extractor" do
      subject.build(:extractor).and_wait
      subject.extractors.length.should == 1
      subject.extractors.first.should be_kind_of(SC2::Structures::Extractor)
    end
  end
end
