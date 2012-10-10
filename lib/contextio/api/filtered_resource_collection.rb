require_relative 'resource_collection'

class ContextIO
  class API
    # When `include`d into a class, thic module provides helper methods for
    # collections of resources like `ContextIO::API::ResourceCollection`, but
    # with a few extra affordances allowing the user to filter the collection.
    module FilteredResourceCollection
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

      # Iterates over the resources in question.
      #
      # @example
      #   contextio.connect_tokens.each do |connect_token|
      #     puts connect_token.email
      #   end
      def each(&block)
        result_array = api.request(:get, resource_url)

        result_array.each do |attribute_hash|
          yield resource_class.new(api, attribute_hash)
        end
      end

      # Returns a resource with the given key.
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
      def [](key)
        resource_class.new(api, resource_class.primary_key => key)
      end

      private

      # Make sure a ResourceCollection has the declarative syntax handy.
      def self.included(other_mod)
        other_mod.extend(ContextIO::API::ResourceCollection::DeclarativeClassSyntax)
      end
    end
  end
end
