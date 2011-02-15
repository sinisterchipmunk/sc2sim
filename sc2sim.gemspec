# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sc2sim/version"

Gem::Specification.new do |s|
  s.name        = "sc2sim"
  s.version     = SC2::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Colin MacKenzie IV"]
  s.email       = ["sinisterchipmunk@gmail.com"]
  s.homepage    = "http://thoughtsincomputation.com"
  s.summary     = %q{Attempts to simulate various aspects of StarCraft 2, such as worker mining rate.}
  s.description = %q{Attempts to simulate various aspects of StarCraft 2, such as worker mining rate.}

  s.rubyforge_project = "sc2sim"

  s.add_dependency "activesupport"

  s.add_development_dependency "rink"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
