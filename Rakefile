require 'bundler'
Bundler::GemHelper.install_tasks

desc "Command line interface"
task :cli do
  require 'rink'
  require File.join(File.dirname(__FILE__), "lib/sc2sim")

  class CLI < Rink::Console
    option :namespace => SC2::Simulator.new(:zerg)
    prompt "SC2sim Console > "
  end

  CLI.new
end
