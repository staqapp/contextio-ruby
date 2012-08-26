module ContextIO
  class OAuthProvider < APIResource
    def self.all
      attr_hashes = ContextIO::API.request(:get, 'oauth_providers')

      attr_hashes.map do |attr_hash|
        new(attr_hash)
      end
    end

    def self.create(type, provider_consumer_key, provider_consumer_secret)
      result_hash = ContextIO::API.request(:post, 'oauth_providers', type: type, provider_consumer_key: provider_consumer_key, provider_consumer_secret: provider_consumer_secret)

      return fetch(result_hash['provider_consumer_key'])
    end

    def self.fetch(key)
      result_hash = ContextIO::API.request(:get, "oauth_providers/#{key}")
      new(result_hash)
    end

    attr_reader :type, :provider_consumer_key, :provider_consumer_secret

    def delete
      ContextIO::API.request(:delete, "oauth_providers/#{provider_consumer_key}")
    end
  end
end
