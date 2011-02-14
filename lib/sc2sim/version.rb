module SC2
  module VERSION
    MAJOR = 0
    MINOR = 0
    PATCH = 0
    BUILD = 1

    STRING = "#{MAJOR}.#{MINOR}.#{PATCH}#{(BUILD.nil? ? "" : ".#{BUILD}")}"
  end
end
