class ContextIO
  class API
    # When `include`d into a class, this module provides some helper methods for
    # various things a singular resource will need or find useful.
    module Resource
      # (see ContextIO#api)
      attr_reader :api

      # (see ContextIO::OAuthProviderCollection#initialize)
      def initialize(api, options = {})
        validate_options(options)

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

      # Deletes the resource.
      #
      # @return [Boolean] Whether the deletion worked or not.
      def delete
        api.request(:delete, resource_url)['success']
      end

      # @!attribute [r] api_attributes
      # @return [{String => Numeric, String, Hash, Array, Boolean}] The
      #   attributes returned from the API as a Hash. If it hasn't been
      #   populated, it will ask the API and populate it.
      def api_attributes
        @api_attributes ||= fetch_attributes
      end

      private

      # Make sure a Resource has the declarative syntax handy.
      def self.included(other_mod)
        other_mod.extend(DeclarativeClassSyntax)
      end

      # Raises ArgumentError unless the primary key or the resource URL is
      # supplied. Use this to ensure that the initializer has or can build the
      # right URL to fetch its self. It relies on the `include`ing class to
      # define a `primary_key` method which should return a String or Symbol.
      def validate_options(options_hash)
        required_keys = ['resource_url', :resource_url]

        if self.respond_to?(:primary_key)
          required_keys << primary_key.to_s
          required_keys << primary_key.to_sym
        end

        if (options_hash.keys & required_keys).empty?
          raise ArgumentError, "Required option missing. Make sure you have either resource_url or #{primary_key}."
        end
      end

      # Fetches attributes from the API for the resource. Relies on having a
      # handle on a `ContextIO::API` via an `api` method and on a `resource_url`
      # method that returns the path for the resource.
      #
      # Defines getter methods for any attributes that come back and don't
      # already have them. This way, if the API expands, the gem will still let
      # users get attributes we didn't explicitly declare as lazy.
      def fetch_attributes
        api.request(:get, resource_url).each do |key, value|
          unless respond_to?(key)
            self.define_singleton_method(key) do
              value
            end
          end
        end
      end

      # This module contains helper methods for `API::Resource`s' class
      # definitions. It gets `extend`ed into a class when `API::Resource` is
      # `include`d.
      module DeclarativeClassSyntax
        def primary_key
          @primary_key
        end

        private

        # Declares the primary key used to build the resource URL. Consumed by
        # `Resource#validate_options`.
        #
        # @param [String, Symbol] key Primary key name.
        def primary_key=(key)
          @primary_key = key

          define_method(:primary_key) do
            self.class.primary_key
          end
        end

        # Declares a list of attributes to be lazily loaded from the API. Getter
        # methods are written for each attribute. If the user asks for one and
        # the object in question doesn't have it already, then it will look for
        # it in the api_attributes Hash.
        #
        # @example an example of the generated methods
        #   def some_attribute
        #     return @some_attribute if instance_variable_defined?(@some_attribute)
        #     api_attributes["some_attribute"]
        #   end
        #
        # @param [Array<String, Symbol>] attributes Attribute names.
        def lazy_attributes(*attributes)
          attributes.each do |attribute_name|
            define_method(attribute_name) do
              return instance_variable_get("@#{attribute_name}") if instance_variable_defined?("@#{attribute_name}")
              api_attributes[attribute_name.to_s]
            end
          end
        end
      end
    end
  end
end
