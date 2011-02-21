class SC2::Adjectives::Percent < SC2::Adjectives::Base
  attr_reader :of_what
  
  def initialize(portion, of_what)
    super(portion)
    @of_what = of_what
  end
end