require_relative 'connect_token'
require_relative 'api/resource_collection'

class ContextIO
  # Represents a collection of connect tokens for your account. You can use this
  # to create a new token, fetch a specific one or iterate over them.
  #
  # @example You can iterate over them with `each`:
  #   contextio.connect_tokens.each do |connect_token|
  #     puts connect_token.email
  #   end
  #
  # @example You can lazily access a specific one with square brackets:
  #   connect_token = contextio.connect_tokens['some_token']
  class ConnectTokenCollection
    include ContextIO::API::ResourceCollection

    self.resource_url = 'connect_tokens'
    self.resource_class = ContextIO::ConnectToken

    # Creates a new connect token for your account.
    #
    # @param [String] callback_url The url that the user will be redirected to
    #   after OAuthing their account with Context.IO.
    # @param [Hash{String, Symbol => String}] options Optional information you
    #   can provide at creation: email, service level, first_name and/or
    #   last_name.
    #
    # @return [ConnectToken] A new token instance based on the data you input.
    def create(callback_url, options={})
      result_hash = api.request(
        :post,
        resource_url,
        callback_url: callback_url,
        email: options[:email],
        service_level: options[:service_level],
        first_name: options[:first_name],
        last_name: options[:last_name]
      )

      result_hash.delete(:success)

      resource_class.new(api, result_hash)
    end
  end
end
