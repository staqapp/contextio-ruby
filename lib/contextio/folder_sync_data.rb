class ContextIO
  class FolderSyncData
    attr_reader :name

    def initialize(name, attr_hash)
      @name = name
      @attr_hash = attr_hash
    end

    def initial_import_finished?
      attr_hash['initial_import_finished']
    end

    def last_expunged_at
      Time.at(attr_hash['last_expunge'])
    end

    def last_sync_started_at
      Time.at(attr_hash['last_sync_start'])
    end

    def last_sync_stopped_at
      Time.at(attr_hash['last_sync_stop'])
    end

    private

    def attr_hash
      @attr_hash
    end
  end
end
