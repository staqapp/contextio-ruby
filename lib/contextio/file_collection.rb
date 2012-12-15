require_relative 'api/resource_collection'
require_relative 'file'

class ContextIO
  class FileCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::File
    self.association_name = :files

    belongs_to :account
  end
end
