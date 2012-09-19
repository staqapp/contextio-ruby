class ContextIO
  class API
    # When `include`d into a class, this module defines `fetch_attributes` for
    # that class. It relies on the including class to have an `api` method that
    # returns a ContextIO::API and a `resource_url` method that returns the path
    # for the given resource.
    module FetchAttributes
      private

      # Fetches attributes from the API for this resource.
      #
      # Defines getter methods for any attributes that come back and don't
      # already have them. This way, if the API expands, the gem will still let
      # users get attributes we didn't explicitly declare as lazy.
      def fetch_attributes
        attr_hashes = api.request(:get, resource_url)

        attr_hashes.each do |key, value|
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
    end
  end
end
