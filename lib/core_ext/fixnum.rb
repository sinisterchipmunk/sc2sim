class Fixnum
  def supply
    SC2::Adjectives::Supply.new(self)
  end
  
  def gas
    SC2::Adjectives::Gas.new(self)
  end
  
  def minerals
    SC2::Adjectives::Minerals.new(self)
  end
  
  def percent(of_what)
    SC2::Adjectives::Percent.new(self, of_what)
  end
  
  def per_cent(of_what)
    percent(of_what)
  end
end
