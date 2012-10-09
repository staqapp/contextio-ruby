require_relative 'connect_token'

class ContextIO
  # Represents a collection of connect tokens for your account. You can use this
  # to create a new token, fetch a specific one or iterate over them.
  class ConnectTokenCollection
    include ContextIO::API::ResourceCollection

    # Creates a new connect token for your account.
    #
    # @param [String] callback_url The url that the user will be redirected to
    #   after OAuthing their account with Context.IO.
    # @param [Hash{String, Symbol => String}]
    #
    # @return [ConnectToken] A new token instance based on the data you input.
    def create(callback_url, options={})
      result_hash = api.request(
        :post,
        'connect_tokens',
        callback_url: callback_url,
        email: options[:email],
        service_level: options[:service_level],
        first_name: options[:first_name],
        last_name: options[:last_name]
      )

      result_hash.delete(:success)

      ContextIO::ConnectToken.new(api, result_hash)
    end

    # Returns a connect token with the given token.
    #
    # This is a lazy method, making no requests. When you try to access
    # attributes on the object, or otherwise interact with it, it will actually
    # make requests.
    #
    # @example
    #   ct = contextio.connect_tokens['1234']
    #
    # @param [String] token The token associated with the connect token you want
    #   to interact with.
    def [](token)
      ContextIO::ConnectToken.new(api, token: token)
    end
  end
end
