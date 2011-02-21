# Build orders, which was the whole reason I started this gem.
# Each of these tests simply runs a build order, and is
# considered to have passed if no errors are raised.
#
require 'spec_helper'

describe "Build order:" do
  describe "5 Roach Rush with Fast Expand" do
    game = SC2::Simulator.new(:zerg) do
      3.times { build :drone }
      build :overlord
      6.times { build :drone }
      build :spawning_pool
      2.times { build :drone }
      build :hatchery
      build :extractor
      build :drone
      build :zerglings
      build :roach_warren
      build :overlord
      wait_for(:extractor)
      drones[0..2].gather(extractors.first)
      build :drone
      4.times { build :roach }
      build :drone
      build :roach
      wait_for(:everything)
    end
  end
  
  describe "Roach Expand" do
    game = SC2::Simulator.new(:zerg) do
      3.times { build(:drone) }
      build :overlord # at 9/10
      build :drone
      # scout with drone.
      # At this point we're supply blocked with an OL on the way, so...
      wait_for_supply
      5.times { build :drone }
      build :spawning_pool # at 15/18
      build :drone
      build :drone
      build(:extractor)    # at 16/18
      drones[0..2].gather(extractors.first)
      build :drone
      build :overlord      # at 16/18
      wait_for :spawning_pool
      build :queen
      build :queen
      build :overlord
      build :overlord
      build :roach_warren
      build :drone
      wait_for :queen
      cast :spawn_larvae   # at 22/34
      wait_for :spawn_larvae
      7.times { build(:roach) }
      # bringing us to 34/34. OL spawn for 34/42.
      wait
    end
  end
end
