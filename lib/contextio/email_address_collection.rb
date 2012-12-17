require_relative 'api/resource_collection'
require_relative 'email_address'

class ContextIO
  class EmailAddressCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::EmailAddress
    self.association_name = :email_addresses

    belongs_to :account

    def create(address)
      result_hash = api.request(:post, resource_url, email_address: address)

      result_hash.delete('success')

      resource_class.new(api, result_hash)
    end
  end
end
