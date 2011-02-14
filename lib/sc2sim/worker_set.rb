class SC2::WorkerSet < Array
  # Average gas income per worker per second; defaults to 2
  attr_accessor :gas_rate
  # Average mineral income per worker per second; defaults to 1
  attr_accessor :mineral_rate

  def initialize(count, type)
    super()
    @gas_rate = 2
    @mineral_rate = 1
    count.times { push type.new }
  end

  def gather(what)
    each { |worker| worker.gather(what) }
  end

  def gas(seconds)
    amount = seconds * gas_rate
    inject(0) { |qty, worker| qty + (worker.gathering?(:gas) ? amount : 0) }
  end

  def minerals(seconds)
    amount = seconds * mineral_rate
    inject(0) { |qty, worker| qty + (worker.gathering?(:minerals) ? amount : 0) }
  end
end
