require File.join(File.dirname(__FILE__), "../lib/sc2sim")
require 'rspec'

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |fi| require fi }

RSpec.configure do |config|
  config.include WorkerMatcher
end
