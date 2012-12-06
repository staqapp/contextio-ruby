class ContextIO
  class SourceCollection
    include ContextIO::API::ResourceCollection

    self.association_name = :sources
  end
end
