class ContextIO
  attr_reader :api

  def initialize(key, secret)
    @api = API.new(key, secret)
  end

  def oauth_providers
    OAuthProviderCollection.new(api)
  end
end

require_relative 'contextio/version'

# require_relative 'contextio/errors'

require_relative 'contextio/api'

require_relative 'contextio/oauth_provider_collection'

# require_relative 'contextio/api_resource'
# require_relative 'contextio/email_settings'
# require_relative 'contextio/connect_token'
# require_relative 'contextio/oauth_provider'
# require_relative 'contextio/account'
