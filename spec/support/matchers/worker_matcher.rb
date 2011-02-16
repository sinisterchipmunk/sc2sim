module WorkerMatcher
  class WorkerMatcher
    def initialize(resource)
      @resource = resource
    end
    
    def matches?(worker)
      @found = worker.gather_source
      worker.gathering?(@resource)
    end
    
    def failure_message
      "expected worker to be gathering #{@resource.inspect}, but was actually gathering #{@found.inspect}"
    end
    
    def negative_failure_message
      "expected worker not to be gathering #{@resource.inspect}, but was"
    end
  end
  
  def be_gathering(what)
    WorkerMatcher.new(what)
  end
end