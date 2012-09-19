class ContextIO
  # Represents a collection of connect tokens for your account. You can use this
  # to create a new token, fetch a specific one or iterate over them.
  class ConnectTokenCollection
    # (see ContextIO#api)
    attr_reader :api

    # (see OAuthProviderCollection#initialize)
    def initialize(api)
      @api = api
    end
  end
end
