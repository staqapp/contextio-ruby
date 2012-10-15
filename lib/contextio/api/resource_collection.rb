class ContextIO
  class API
    # When `include`d into a class, this module provides some helper methods for
    # various things a collections of resources will need or find useful.
    module ResourceCollection
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
      def initialize(api, options={})
        @api = api
        @where_constraints = options[:where] || {}
        @attribute_hashes = options[:attribute_hashes]
      end

      # Iterates over the resources in question.
      #
      # @example
      #   contextio.connect_tokens.each do |connect_token|
      #     puts connect_token.email
      #   end
      def each(&block)
        attribute_hashes.each do |attribute_hash|
          yield resource_class.new(api, attribute_hash)
        end
      end

      # Specify one or more constraints for limiting resources in this
      # collection. See individual classes for the list of valid constraints.
      #
      # This can be chained at need and doesn't actually cause the API to get
      # hit until some iterator is called like `#each`.
      #
      # @param [Hash{String, Symbol => String, Integer}] constraints A Hash
      #   mapping keys to the desired limiting values.
      def where(constraints)
        self.class.new(api, where: where_constraints.merge(constraints))
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

      # @!attribute [r] attribute_hashes
      #   @return [Array<Hash>] An array of attribute hashes that describe, at
      #     least partially, the objects in this collection.
      def attribute_hashes
        @attribute_hashes ||= api.request(:get, resource_url, where_constraints)
      end

      # Make sure a ResourceCollection has the declarative syntax handy.
      def self.included(other_mod)
        other_mod.extend(DeclarativeClassSyntax)
      end

      # This module contains helper methods for `API::ResourceCollection`s'
      # class definitions. It gets `extend`ed into a class when
      # `API::ResourceCollection` is `include`d.
      module DeclarativeClassSyntax
        private

        # Declares which class the `ResourceCollection` is intended to wrap. For
        # best results, this should probably be a `Resource`. It defines an
        # accessor for this class on instances of the collection, which is
        # private. Make sure your collection class has required the file with
        # the defeniiton of the class it wraps.
        #
        # @param [Class] klass The class that the collection, well, collects.
        def resource_class=(klass)
          define_method(:resource_class) do
            klass
          end
        end

        # Declares the path that this resource collection lives at.
        #
        # @param [String] url The path that refers to this collection of
        #   resources.
        def resource_url=(url)
          define_method(:resource_url) do
            url
          end
        end
      end
    end
  end
end
