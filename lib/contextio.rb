module ContextIO
  # contextio version
  VERSION = "0.5.0"

  def self.version
    VERSION
  end
end

require_relative 'contextio/errors'

require_relative 'contextio/api'

require_relative 'contextio/api_resource'
require_relative 'contextio/email_settings'
require_relative 'contextio/connect_token'
require_relative 'contextio/oauth_provider'
require_relative 'contextio/account'
