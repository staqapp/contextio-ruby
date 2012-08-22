require 'json'

module ContextIO
  class APIResource
    def initialize(attributes)
      attributes.each do |name, value|
        unless self.respond_to?("#{name}")
          raise ArgumentError, "Unknown attribute '#{name}' for #{self.class.name}"
        end

        self.instance_variable_set("@#{name}", value)
      end
    end
  end
end
