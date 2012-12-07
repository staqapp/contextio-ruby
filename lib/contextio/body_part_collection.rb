require_relative 'api/resource_collection'
require_relative 'body_part'

class ContextIO
  class BodyPartCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::BodyPart
    self.association_name = :body_parts

    belongs_to :message
  end
end
