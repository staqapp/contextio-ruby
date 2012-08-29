require 'json'

module ContextIO
  class APIResource
    def initialize(attributes)
      attributes.each do |name, value|
        self.instance_variable_set("@#{name}", value)
      end
    end

    def url
      self.class.instance_url(primary_key)
    end

    module All
      def all
        attr_hashes = ContextIO::API.request(:get, url)

        attr_hashes.map do |attr_hash|
          new(attr_hash)
        end
      end
    end

    module Fetch
      def fetch(key)
        result_hash = ContextIO::API.request(:get, instance_url(key))
        new(result_hash)
      end
    end

    module Delete
      def delete
        ContextIO::API.request(:delete, url)
      end
    end
  end
end
