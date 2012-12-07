require_relative 'api/resource_collection'
require_relative 'message'

class ContextIO
  class MessageCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::Message
    self.association_name = :messages

    belongs_to :account
  end
end
