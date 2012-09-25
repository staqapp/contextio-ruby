class ContextIO
  class API
    # When `include`d into a class, this module provides some helper methods for
    # various things a singular resource's initialize method probably needs to
    # do.
    module ResourceInitializer
      private

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
    end
  end
end
