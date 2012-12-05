class ContextIO
  class API
    module ResourceHelpers
      # Utility method for turning class names into association names.
      # Inspired by Rails's String#underscore.
      #
      # @param [String, Symbol] class_name The name of the class to be transformed.
      #
      # @return [String] The class's name clipped to the last :: and
      #   underscored.
      def self.class_to_association_name(class_name)
        class_name.
          to_s.
          split('::').
          last.
          gsub(/(?:([A-Za-z\d])|^)([A-Z])/) {
            "#{$1}#{$1 && '_'}#{$2.downcase}"
          }.
          gsub(/_collection/, 's')
      end
    end
  end
end
