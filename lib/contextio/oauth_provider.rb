class ContextIO
  class OAuthProvider
    attr_reader :api, :provider_consumer_key

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

    private

    def build_resource_url
      "oauth_providers/#{provider_consumer_key}"
    end
  end
end
