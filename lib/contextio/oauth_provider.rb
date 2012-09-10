class ContextIO
  class OAuthProvider
    attr_reader :api

    def initialize(api, options = {})
      required_options = [:provider_consumer_key, 'provider_consumer_key', :resource_url, 'resource_url']

      if (options.keys & required_options).empty?
        raise ArgumentError, "Either a provider_consumer_key or a resource_url is required"
      end

      @api = api

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def resource_url
      @resource_url ||= build_resource_url
    end

    def type
      return @type if defined?(@type)

      fetch_attributes

      @type
    end

    def provider_consumer_key
      return @provider_consumer_key if defined?(@provider_consumer_key)

      fetch_attributes

      @provider_consumer_key
    end

    private

    def build_resource_url
      "oauth_providers/#{provider_consumer_key}"
    end

    def fetch_attributes
      attr_hashes = api.request(:get, resource_url)

      attr_hashes.each do |key, value|
        instance_variable_set("@#{key}", value)

        unless respond_to?(key)
          instance_eval <<-RUBY
            def #{key}
              @#{key}
            end
          RUBY
        end
      end
    end
  end
end
