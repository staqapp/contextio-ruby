class ContextIO
  class API
    # When `extend`ed into a class, this module allows for a declaritive syntax
    # for listing attributes to be lazily loaded.
    module LazyAttributes
      private

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
          # teh metapr0gramz0rz!

          class_eval <<-RUBY
            def #{attribute_name}
              return @#{attribute_name} if defined?(@#{attribute_name})

              fetch_attributes

              @#{attribute_name}
            end
          RUBY
        end
      end
    end
  end
end
