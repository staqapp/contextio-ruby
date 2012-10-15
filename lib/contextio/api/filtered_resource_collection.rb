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

      # @!attribute [r] where_constraints
      #   A Hash of the constraints limiting this collection of resources.
      attr_reader :where_constraints

      # @private
      #
      # For internal use only. Users of this gem shouldn't be calling this
      # directly.
      #
      # @param [API] api A handle on the Context.IO API.
      # @param [Hash] where_constraints The constraints on this collection that
      #   control which resources belong to it.
      def initialize(api, where_constraints = {})
        @api = api
        @where_constraints = where_constraints
      end

      # Iterates over the resources in question.
      #
      # @example
      #   contextio.connect_tokens.each do |connect_token|
      #     puts connect_token.email
      #   end
      def each(&block)
        result_array = api.request(:get, resource_url, where_constraints)

        result_array.each do |attribute_hash|
          yield resource_class.new(api, attribute_hash)
        end
      end
      #
      # Specify one or more constraints for limiting resources in this
      # collection. See individual classes for the list of valid constraints.
      #
      # This can be chained at need and doesn't actually cause the API to get
      # hit until some iterator is called like `#each`.
      #
      # @param [Hash{String, Symbol => String, Integer}] constraints A Hash
      #   mapping keys to the desired limiting values.
      def where(constraints)
        self.class.new(api, where_constraints.merge(constraints))
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
      # @param [String] key The Provider Consumer Key for the
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
