require 'spec_helper'

describe "Build order:" do
  context "optimized by Evolution Chamber" do
    # These orders were optimized by Evolution Chamber. I'm using them
    # to test timing similarities. My timings may not be identical so
    # we'll give it +/- 10 seconds.
    
    it "6 zerglings" do
      game = SC2::BuildOrder.new(:zerg) do
        at 7, :spawning_pool
        at 9, :overlord
        3.times { build :zerglings }
        wait_for :everything
      end
      
      game.time.should be > 144
      game.time.should be < 154
    end
    
    it "5 roaches" do
      game = SC2::BuildOrder.new(:zerg) do
        at 8, :spawning_pool
        at 10, :extractor_trick
        at 11, :overlord
        at 11, :roach_warren
        at 11, :extractor
        at 12, :overlord
        at(12) { drones[0..1].gather(extractors.last) }
        at 12, :overlord
        at 12, :roach
        at(14) { drones[2].gather(extractors.last) }
        at 14, :roach
        at 16, :roach
        at 18, :roach
        at 20, :roach
        
        wait_for :everything
      end
      
      game.time.should be > 271
      game.time.should be < 291
    end
  end
  
  it "5 Roach Rush Expand" do
    game = SC2::BuildOrder.new(:zerg) do
      at 10, :overlord
      at 11, :spawning_pool
      at 12, :extractor
      at(:extractor) { drones[0..2].gather extractors.last }
      at 14, :zerglings
      at 15, :queen
      at 18, :roach_warren
      at :queen, :cast => :spawn_larvae
      at 100.gas, :metabolic_boost
      at(125.gas) { drones.gather :minerals }
      at 18, :overlord
      at 19, :overlord
      at(19) { 5.times { build :roach } }
      at 29, :hatchery
      
      wait_for :roach while building? :roach
    end

#    p game
  end
  

  it "Roach Expand" do
    game = SC2::BuildOrder.new(:zerg) do
      at 9, :overlord
      at 10, :worker_scout
      at 15, :spawning_pool
      at 16, :extractor
      at(:extractor) { drones[0..2].gather(extractors.last) }
      at 16, :overlord
      at 18, :queen
      at 75.percent(:queen), :roach_warren
      at 18, :overlord
      at :queen, :cast => :spawn_larvae
      7.times { build(:roach).and_wait }
      at 34, :overlord
      at 34, :hatchery
    end

#    p game
  end
end
