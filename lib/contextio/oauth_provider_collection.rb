require_relative 'oauth_provider'
require_relative 'api/resource_collection'

class ContextIO
  # Represents a collection of OAuth providers for an account. You can use this
  # to create a proider, fetch a specific one or iterate over them.
  #
  # @example You can iterate over them with `each`:
  #   contextio.oauth_providers.each do |oauth_provider|
  #     puts oauth_provider.type
  #   end
  #
  # @example You can lazily access a specific one with square brackets:
  #   provider = contextio.oauth_providers['some_provider_consumer_key']
  class OAuthProviderCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::OAuthProvider
    self.association_name = :oauth_providers

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
        resource_url,
        type: type,
        provider_consumer_key: provider_consumer_key,
        provider_consumer_secret: provider_consumer_secret
      )

      result_hash.delete('success')

      resource_class.new(api, result_hash)
    end
  end
end
