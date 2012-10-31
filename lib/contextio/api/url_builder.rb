require 'contextio/connect_token'
require 'contextio/oauth_provider'

class ContextIO
  class API
    class URLBuilder
      class Error < StandardError; end

      # Tells you the right URL for a resource to fetch attributes from.
      #
      # @param [ContextIO::Resource, ContextIO::ResourceCollection] resource The
      #   resource or resource collection.
      #
      # @return [String] The path for that resource in the API.
      def self.url_for(resource)
        if (builder = @registered_urls[resource.class])
          builder.call(resource)
        else
          raise Error, "URL could not be built for unregistered Class."
        end
      end

      # Register a block that calculates the URL for a given resource.
      #
      # @param [Class] resource_class The class of the resource you are
      #   registering.
      # @param [Block] block The code that will compute the url for the
      #   resource. This is actually a path. Start after the version number of
      #   the API in the URL. When a URL is being calculated for a specific
      #   resource, the resource instance will be yielded to the block.
      #
      # @example For Accounts
      #   register_url ContextIO::Account do |account|
      #     "accounts/#{account.id}"
      #   end
      def self.register_url(resource_class, &block)
        @registered_urls ||= {}
        @registered_urls[resource_class] = block
      end

      register_url ContextIO::ConnectToken do |connect_token|
        "connect_tokens/#{connect_token.token}"
      end

      register_url ContextIO::OAuthProvider do |oauth_provider|
        "oauth_providers/#{oauth_provider.provider_consumer_key}"
      end
    end
  end
end
