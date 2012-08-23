require 'json'

module ContextIO
  class APIResource
    def initialize(attributes)
      attributes.each do |name, value|
        self.instance_variable_set("@#{name}", value)
      end
    end
  end
end
