require 'contextio/api/resource'

class ContextIO
  class File
    include ContextIO::API::Resource

    self.primary_key = :file_id
    self.association_name = :file

    belongs_to :account

    lazy_attributes :size, :type, :subject, :date, :addresses, :personInfo,
                    :email_message_id, :message_id, :date_indexed,
                    :date_received, :file_name, :file_name_structure,
                    :body_section, :content_disposition, :file_id,
                    :is_tnef_part, :gmail_message_id, :gmail_thread_id,
                    :supports_preview, :is_embedded
    private :date, :addresses, :message_id, :date_indexed, :date_received,
            :is_tnef_part, :is_embedded, :personInfo

    def received_at
      @received_at ||= Time.at(date_received)
    end

    def indexed_at
      @indexed_at ||= Time.at(indexed_at)
    end

    def to
      addresses['to']
    end

    def from
      addresses['from']
    end

    def person_info
      personInfo
    end

    def tnef_part?
      !!is_tnef_part
    end

    def embedded?
      !!is_embedded
    end
  end
end
