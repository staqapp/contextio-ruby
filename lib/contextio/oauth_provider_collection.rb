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

      ContextIO::OAuthProvider.new(api, result_hash)
    end

    def each(&block)
      result_array = api.request(:get, 'oauth_providers')

      result_array.each do |attribute_hash|
        yield OAuthProvider.new(api, attribute_hash)
      end
    end

    def [](provider_consumer_key)
      ContextIO::OAuthProvider.new(api, provider_consumer_key: provider_consumer_key)
    end
  end
end
