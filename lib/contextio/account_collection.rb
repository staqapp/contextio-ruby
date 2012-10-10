require_relative 'api/filtered_resource_collection'
require_relative 'account'

class ContextIO
  # Represents a collection of email accounts for your Context.IO account. You
  # can use this to add a new one to your account, iterate over them, or fetch a
  # specific one.
  #
  # You can also limit which accounts belongin the collection using the `where`
  # method. Valid keys are: email, status, status_ok, limit and offset. See
  # [the Context.IO documentation](http://context.io/docs/2.0/accounts#get) for
  # more explanation of what each key means.
  #
  # @example You can iterate over them with `each`:
  #   contextio.accounts.each do |accounts|
  #     puts account.email_addresses
  #   end
  #
  # @example You can lazily access a specific one with square brackets:
  #   account = contextio.accounts['some id']
  #
  # @example Lazily limit based on a hash of criteria with `where`:
  #   disabled_accounts = contextio.accounts.where(status: 'DISABLED')
  class AccountCollection
    include ContextIO::API::FilteredResourceCollection

    self.resource_url = 'accounts'
    self.resource_class = ContextIO::Account
  end
end
