# Provides an object-oriented interface for the Context.IO API.
#
# To use it, you have to [sign up for an account](http://context.io).
#
# Once you have an account, you can create a new `ContextIO` object and interact
# with the API using the methods on that object as a starting point.
class ContextIO
  # @private
  # Handle for the `API` instance. For internal use only.
  attr_reader :api

  # Creates a new `ContextIO` instance and makes a new handle for the API.
  # This is your entry point to your Context.IO account.  For a web app, you
  # probably want to instantiate this in some kind of initializer and keep it
  # around for the life of the process.
  #
  # @param [String] key Your OAuth consumer key for your Context.IO account
  # @param [String] secret Your OAuth consumer secret for your Context.IO
  #   account
  def initialize(key, secret)
    @api = API.new(key, secret)
  end

  # Your entry point for dealing with oauth providers.
  #
  # @return [OAuthProviderCollection] Allows you to work with the providers for
  #   your account as a group.
  def oauth_providers
    OAuthProviderCollection.new(api)
  end
end

require_relative 'contextio/version'

require_relative 'contextio/api'

require_relative 'contextio/oauth_provider_collection'

# require_relative 'contextio/api_resource'
# require_relative 'contextio/email_settings'
# require_relative 'contextio/connect_token'
# require_relative 'contextio/oauth_provider'
# require_relative 'contextio/account'
