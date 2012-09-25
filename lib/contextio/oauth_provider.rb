require 'contextio/api/resource'

class ContextIO
  # Represents a single OAuth provider for an account. You can use this to
  # inspect or delete the provider. Most of the attributes are lazily loaded,
  # meaning that the API won't get hit until you ask for an attribute the object
  # doesn't already have (presumably from a previous API call).
  class OAuthProvider
    include API::Resource

    # (see ContextIO#api)
    attr_reader :api

    # @!attribute [r] provider_consumer_key
    #   @return [String] The consumer key associated with this provider. Will
    #     fetch from the API if necessary.
    # @!attribute [r] provider_consumer_secret
    #   @return [String] The consumer secret associated with this provider. Will
    #     fetch from the API if necessary.
    # @!attribute [r] type
    #   @return [String] The consumer key associated with this provider. Will
    #     fetch from the API if necessary.
    lazy_attributes :provider_consumer_key, :provider_consumer_secret, :type

    # (see ContextIO::OAuthProviderCollection#initialize)
    def initialize(api, options = {})
      validate_required_options(options)

      @api = api

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # @!attribute [r] resource_url
    # @return [String] The URL that will fetch attributes from the API.
    def resource_url
      @resource_url ||= build_resource_url
    end

    # Deletes the provider instance.
    #
    # @return [Boolean] Whether the deletion worked or not.
    def delete
      api.request(:delete, resource_url)['success']
    end

    private

    # Required options for ResourceInitializer.
    def required_options
      %w(provider_consumer_key resource_url)
    end

    # Builds the path that will fetch the attributes for this provider.
    #
    # @return [String] The path of the resource.
    def build_resource_url
      "oauth_providers/#{provider_consumer_key}"
    end
  end
end
