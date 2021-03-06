class SC2::WorkerSet < Array
  include SC2::MetaData
  
  def initialize(count, type)
    super()
    count.times { push type.new }
  end
  
  def stop_gathering(what = nil)
    each { |worker| worker.stop_gathering(what) }
  end

  def gather(what)
    each { |worker| worker.gather(what) }
  end

  def gas(seconds)
    gas_sources.inject(0) do |qty, src|
      qty + src.income_per_second * seconds
    end 
  end
  
  def gas_sources
    select { |worker| worker.gathering?(:gas) }.collect { |worker| worker.gather_source }.uniq
  end

  def minerals(seconds)
    amount = seconds * mineral_rate
    inject(0) { |qty, worker| qty + (worker.gathering?(:minerals) ? amount : 0) }
  end

  # Returns true if any workers are gathering the requested resource (:minerals, :gas, or a specific
  # extractor, assimilator or refinery)
  def gathering?(what)
    !select { |worker| worker.gathering?(what) }.empty?
  end
end
