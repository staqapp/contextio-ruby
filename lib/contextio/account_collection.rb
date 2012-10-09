require_relative 'api/resource_collection'

class ContextIO
  # Represents a collection of email accounts for your Context.IO account. You
  # can use this to add a new one to your account, iterate over them, or fetch a
  # specific one.
  #
  # @example You can iterate over them with `each`:
  #   contextio.accounts.each do |accounts|
  #     puts account.email_addresses
  #   end
  #
  # @example You can lazily access a specific one with square brackets:
  #   account = contextio.accounts['some id']
  class AccountCollection
    include ContextIO::API::ResourceCollection

    self.resource_url = 'accounts'
    self.resource_class = ContextIO::Account
  end
end
