require_relative 'api/resource_collection'
require_relative 'email_address'

class ContextIO
  class EmailAddressCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::EmailAddress
    self.association_name = :email_addresses

    belongs_to :account
  end
end
