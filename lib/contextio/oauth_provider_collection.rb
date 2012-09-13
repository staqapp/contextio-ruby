require_relative 'oauth_provider'

class ContextIO
  # Represents a collection of OAuth providers for an account. You can use this
  # to create a proider, fetch a specific one or iterate over them.
  class OAuthProviderCollection
    include Enumerable

    # (see ContextIO#api)
    attr_reader :api

    # @private
    #
    # For internal use only. Users of this gem shouldn't be calling this
    # directly.
    #
    # @param [API] api A handle on the Context.IO API.
    def initialize(api)
      @api = api
    end

    # Creates a new OAuth provider for your account.
    #
    # @param [String] type The type of provider. As of this writing, the API
    #   only accepts 'GMAIL' and 'GOOGLEAPPSMARKETPLACE'.
    # @param [String] provider_consumer_key The Provider Consumer Key you got
    #   when you OAuthed the user.
    # @param [String] provider_consumer_secret The Provider Consumer Secret you
    #   got when you OAuthed the user.
    #
    # @return [OAuthProvider] A new provider instance based on the data you
    #   input.
    def create(type, provider_consumer_key, provider_consumer_secret)
      result_hash = api.request(
        :post,
        'oauth_providers',
        type: type,
        provider_consumer_key: provider_consumer_key,
        provider_consumer_secret: provider_consumer_secret
      )

      result_hash.delete(:success)

      ContextIO::OAuthProvider.new(api, result_hash)
    end

    # Iterates over the providers in your account.
    #
    # @example
    #   contextio.oauth_providers.each do |provider|
    #     puts provider.provider_consumer_key
    #   end
    def each(&block)
      result_array = api.request(:get, 'oauth_providers')

      result_array.each do |attribute_hash|
        yield OAuthProvider.new(api, attribute_hash)
      end
    end

    # Returns a provider with the given consumer key.
    #
    # This is a lazy method, making no requests. When you try to access
    # attributes on the object, or otherwise interact with it, it will actually
    # make requests.
    #
    # @example
    #   provider = contextio.oauth_providers['1234']
    #
    # @param [String] provider_consumer_key The Provider Consumer Key for the
    #   provider you want to interact with.
    def [](provider_consumer_key)
      ContextIO::OAuthProvider.new(api, provider_consumer_key: provider_consumer_key)
    end
  end
end
