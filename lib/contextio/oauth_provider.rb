class ContextIO
  class OAuthProvider
    attr_reader :api

    def initialize(api, options = {})
      @api = api

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
