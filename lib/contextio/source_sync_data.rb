require_relative 'folder_sync_data'

class ContextIO
  class SourceSyncData
    attr_reader :folder_names, :folders, :source_label

    def initialize(source_label, folder_hash)
      @folder_hash = folder_hash
      @source_label = source_label
      @folder_names = folder_hash.keys

      @folders = folder_hash.collect do |folder_name, attr_hash|
        ContextIO::FolderSyncData.new(folder_name, attr_hash)
      end
    end

    private

    def folder_hash
      @folder_hash
    end
  end
end
