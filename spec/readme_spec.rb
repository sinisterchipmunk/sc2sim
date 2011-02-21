# Makes sure the examples in the README are valid ones.

require 'spec_helper'

describe "README examples" do
  context "for Zerg" do
    subject { SC2::Simulator.new(:zerg) }

    context "mining for 60 seconds" do
      it "should have 410 minerals" do
        # 1 mineral per sec * 6 drones * 60 seconds + 50 starting mins = 410
        subject.drones.gather(:minerals)
        subject.wait(60.seconds)
        subject.minerals.should == 477.2120000000005
      end
    end

    it "should have initial income 360" do
      subject.income.should == 427.212
    end

    it "should have initial minerals 50" do
      subject.minerals.should == 50
    end

    context "after building an extractor and gathering gas for 10 seconds" do
      it "should have 60 gas" do
        subject.build(:extractor).and_wait
        subject.drones[0...3].gather(subject.extractors.first)
        subject.wait(10.seconds)
        subject.vespene.should == 36.75
      end
    end
  end
end
