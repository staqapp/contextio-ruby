require_relative 'connect_token'

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

    # Creates a new connect token for your account.
    def create(callback_url, options={})
      result_hash = api.request(
        :post,
        'connect_tokens',
        callback_url: callback_url
      )

      result_hash.delete(:success)

      ContextIO::ConnectToken.new(api, result_hash)
    end
  end
end
