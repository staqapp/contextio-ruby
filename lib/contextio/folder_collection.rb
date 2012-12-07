require_relative 'api/resource_collection'
require_relative 'folder'

class ContextIO
  class FolderCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::Folder
    self.association_name = :folders

    belongs_to :source
  end
end

