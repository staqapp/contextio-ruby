require 'contextio/api/lazy_attributes'

class ContextIO
  class OAuthProvider
    extend ContextIO::API::LazyAttributes

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
      required_options = [:provider_consumer_key, 'provider_consumer_key', :resource_url, 'resource_url']

      if (options.keys & required_options).empty?
        raise ArgumentError, "Either a provider_consumer_key or a resource_url is required"
      end

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

    # Builds the path that will fetch the attributes for this provider.
    #
    # @return [String] The path of the resource.
    def build_resource_url
      "oauth_providers/#{provider_consumer_key}"
    end

    # Fetches attributes from the API for this provider.
    #
    # Defines getter methods for any attributes that come back and don't already
    # have them. This way, if the API expands, the gem will still let users get
    # attributes we didn't explicitly declare as lazy.
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
