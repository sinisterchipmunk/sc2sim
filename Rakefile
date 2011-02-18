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

gem "hanna"
require "hanna/rdoctask"
desc "Documentation"
Rake::RDocTask.new :rdoc do |rd|
  rd.rdoc_dir = "rdoc"
  rd.title    = "SC2sim"
  rd.options << "--line-numbers" << "--inline-source"
  rd.options << "--charset" << "utf-8"
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc")
  rd.rdoc_files.include("lib/**/*.rb")
end
