class ContextIO
  class OAuthProvider
    attr_reader :api, :provider_consumer_key

    def initialize(api, options = {})
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
