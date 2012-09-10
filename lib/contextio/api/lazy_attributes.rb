class ContextIO
  class API
    module LazyAttributes
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
