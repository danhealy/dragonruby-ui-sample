# Throw this file into your app folder, like app/lib/serializable.rb
#
# In your main.rb or wherever you require files:
#   require 'app/lib/serializable.rb'
#
# In each class you want to automatically serialize:
#   class Foo
#     include Serializable
#     ...
#   end
#
# Automatically defines #serialize based on instance vars with setter methods
module Serializable
  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end

  def serialize
    attrs = {}
    instance_variables.each do |var|
      str = var.to_s.gsub("@", "")
      next if str == "args" # Too much spam

      attrs[str.to_sym] = instance_variable_get var if respond_to? "#{str}="
    end
    attrs
  end
end
