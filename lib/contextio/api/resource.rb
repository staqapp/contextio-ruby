class ContextIO
  class API
    # When `include`d into a class, this module provides some helper methods for
    # various things a singular resource will need or find useful.
    module Resource
      private

      # Make sure a Resource has the declarative syntax handy.
      def self.included(other_mod)
        other_mod.extend(DeclarativeClassSyntax)
      end

      # Raises ArgumentError unless one of the required keys is supplied. Use
      # this to ensure that the initializer has or can build the right URL to
      # fetch its self. It relies on the `include`ing class to define a
      # `required_options` hash which should return an Array of Strings or
      # Symbols.
      #
      # **Important**: This is an OR operation, so only one key needs to be
      # matched.
      def validate_required_options(options_hash)
        normalized_required_options = required_options.inject([]) do |memo, key|
          memo << key.to_s
          memo << key.to_sym
        end

        if (options_hash.keys & normalized_required_options).empty?
          raise ArgumentError, "Required option missing. Make sure you have one of: #{required_options.join(', ')}"
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
        @attr_hashes = api.request(:get, resource_url)

        @attr_hashes.each do |key, value|
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

      # This module contains helper methods for `API::Resource`s' class
      # definitions. It gets `extend`ed into a class when `API::Resource` is
      # `include`d.
      module DeclarativeClassSyntax
        private

        # Declares a list of options that are required. Consumed by
        # `Resource#validate_required_options`.
        #
        # @param [Array<String, Symbol>] args Option key names.
        def required_options(*args)
          define_method(:required_options) do
            Array(args)
          end
        end

        # Declares a list of attributes to be lazily loaded from the API. Getter
        # methods are written for each attribute. If the user asks for one and
        # the object in question doesn't have it already, then it will fetch it
        # from the API, and save the attributes it gets back
        #
        # @example an example of the generated methods
        #   def some_attribute
        #     return @some_attribute if defined?(@some_attribute)
        #
        #     fetch_attributes
        #
        #     @some_attribute
        #   end
        #
        # @param [Array<String, Symbol>] attributes Attribute names.
        def lazy_attributes(*attributes)
          attributes.each do |attribute_name|
            define_method(attribute_name) do
              return instance_variable_get("@#{attribute_name}") if instance_variable_defined?("@#{attribute_name}")

              fetch_attributes

              instance_variable_get("@#{attribute_name}")
            end
          end
        end
      end
    end
  end
end
