require_relative 'oauth_provider'

class ContextIO
  class OAuthProviderCollection
    attr_reader :api

    def initialize(api)
      @api = api
    end

    def create(type, provider_consumer_key, provider_consumer_secret)
      result_hash = api.request(:post, 'oauth_providers', type: type, provider_consumer_key: provider_consumer_key, provider_consumer_secret: provider_consumer_secret)

      result_hash.delete(:success)

      ContextIO::OAuthProvider.new(result_hash)
    end
  end
end
