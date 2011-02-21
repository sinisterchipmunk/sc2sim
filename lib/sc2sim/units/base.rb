class SC2::Units::Base < SC2::GameObject
  def inspect
    ivars = ""
    instance_variables.each { |ivar| ivars = "#{ivars} #{ivar}=#{instance_variable_get(ivar).inspect}" }
    "#<#{self.class.base_name}#{ivars}>"
  end
end
