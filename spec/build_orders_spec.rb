# Build orders, which was the whole reason I started this gem.
# Each of these tests simply runs a build order, and is
# considered to have passed if no errors are raised.
#
require 'spec_helper'

describe "Build order:" do
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
      build :extractor     # at 16/18
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
      cast :spawn_larvae  # at 22/34
      wait_for :spawn_larvae
      7.times { build(:roach) }
      
      wait
      puts inspect
    end
    
    puts game.time
  end
end
