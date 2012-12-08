require_relative 'api/resource_collection'
require_relative 'contact'

class ContextIO
  class ContactCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::Contact
    self.association_name = :contacts

    belongs_to :account

    private

    # The request that comes back is not formatted the same as other
    # collections, so we need to override it and pick out the right key.
    def attribute_hashes
      @attribute_hashes ||= api.request(:get, resource_url, where_constraints)['matches']
    end
  end
end
