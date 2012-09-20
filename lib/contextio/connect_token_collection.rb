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

    # Iterates over the connect tokens in your account.
    #
    # @example
    #   contextio.connect_tokens.each do |connect_token|
    #     puts connect_token.email
    #   end
    def each(&block)
      result_array = api.request(:get, 'connect_tokens')

      result_array.each do |attribute_hash|
        yield ConnectToken.new(api, attribute_hash)
      end
    end
  end
end
