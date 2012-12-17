require_relative 'source_sync_data'

class ContextIO
  class AccountSyncData
    attr_reader :source_labels, :sources

    def initialize(source_hash)
      @source_hash = source_hash
      @source_labels = source_hash.keys

      @sources = source_hash.collect do |source_label, folder_hash|
        ContextIO::SourceSyncData.new(source_label, folder_hash)
      end
    end
  end

  private

  def source_hash
    @source_hash
  end
end
