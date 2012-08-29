module ContextIO
  class OAuthProvider < APIResource
    extend ContextIO::APIResource::All
    extend ContextIO::APIResource::Fetch
    include ContextIO::APIResource::Delete

    def self.url
      'oauth_providers'
    end

    def self.instance_url(key)
      "#{url}/#{key}"
    end

    def self.create(type, provider_consumer_key, provider_consumer_secret)
      result_hash = ContextIO::API.request(:post, 'oauth_providers', type: type, provider_consumer_key: provider_consumer_key, provider_consumer_secret: provider_consumer_secret)

      return fetch(result_hash['provider_consumer_key'])
    end

    attr_reader :type, :provider_consumer_key, :provider_consumer_secret

    def primary_key
      provider_consumer_key
    end
  end
end
