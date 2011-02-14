module SC2::Inspection
  def inspect
    result = "#<#{self.class.name}"
    instance_variables.each do |ivar|
      if !self.class.omitted_instance_variables.include?(ivar)
        result << " #{ivar}=#{instance_variable_get(ivar).inspect}"
      end
    end
    result << ">"

    result
  end

  def self.included(base)
    class << base
      def omitted_instance_variables
        @omitted_instance_variables ||= []
      end

      def omits(what)
        omitted_instance_variables << :"@#{what}"
      end
    end
  end
end
