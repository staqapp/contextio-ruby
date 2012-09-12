class ContextIO
  # This will create an object that can be built from responses from
  # ContextIO::API. To use the submodules, you'll need to implement some simple
  # methods. See below.
  class APIResource
    def initialize(attributes = {})
      attributes.each do |name, value|
        self.instance_variable_set("@#{name}", value)
      end
    end

    # Extend this into an APIResource to list all of it.
    #
    # Implement the class method `url` that returns a string, which is the last
    # part of the list url. For instance, the listing url for accounts is
    # 'https://api.context.io/2.0/accounts', so Account.url returns 'accounts'.
    module All
      def all(options = {})
        attr_hashes = ContextIO::API.request(:get, url, options)

        attr_hashes.map do |attr_hash|
          new(attr_hash)
        end
      end
    end

    # Extend this into an APIResource to fetch a specific instance of it.
    #
    # Implement the class method `url` that returns a string, which is the last
    # part of the list url. For instance, the listing url for accounts is
    # 'https://api.context.io/2.0/accounts', so Account.url returns 'accounts'.
    module Fetch
      def fetch(key)
        result_hash = ContextIO::API.request(:get, instance_url(key))
        new(result_hash)
      end

      def instance_url(key)
        "#{url}/#{key}"
      end
    end

    # Include this into an APIResource to delete an instance of it.
    #
    # Implement an instance method `primary_key` that returns the calue of the
    # primary key for the resource. For instance, the API uses the
    # provider consumer key for the primary identifier for OAuth Providers, so
    # OAuthProvider#primary_key returns the provider_consumer_key.
    #
    # Also, implement the class method `url` that returns a string, which is
    # the last part of the list url. For instance, the listing url for accounts
    # is 'https://api.context.io/2.0/accounts', so Account.url returns
    # 'accounts'.
    module Delete
      def delete
        ContextIO::API.request(:delete, url)['success']
      end

      def url
        "#{self.class.url}/#{primary_key}"
      end
    end
  end
end
