require 'contextio/connect_token'
require 'contextio/connect_token_collection'
require 'contextio/oauth_provider'
require 'contextio/oauth_provider_collection'
require 'contextio/email_settings'
require 'contextio/account'
require 'contextio/account_collection'
require 'contextio/folder_collection'

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
          raise Error, "URL could not be built for unregistered Class: #{resource.class}."
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
        if connect_token.account && connect_token.account.id
          "accounts/#{connect_token.account.id}/connect_tokens/#{connect_token.token}"
        else
          "connect_tokens/#{connect_token.token}"
        end
      end

      register_url ContextIO::ConnectTokenCollection do |connect_tokens|
        if connect_tokens.account && connect_tokens.account.id
          "accounts/#{connect_tokens.account.id}/connect_tokens"
        else
          'connect_tokens'
        end
      end

      register_url ContextIO::OAuthProvider do |oauth_provider|
        "oauth_providers/#{oauth_provider.provider_consumer_key}"
      end

      register_url ContextIO::OAuthProviderCollection do
        'oauth_providers'
      end

      register_url ContextIO::EmailSettings do
        'discovery'
      end

      register_url ContextIO::Account do |account|
        "accounts/#{account.id}"
      end

      register_url ContextIO::AccountCollection do
        'accounts'
      end

      register_url ContextIO::FolderCollection do |folders|
        "accounts/#{folders.source.account.id}/sources/#{folders.source.label}/folders"
      end
    end
  end
end
