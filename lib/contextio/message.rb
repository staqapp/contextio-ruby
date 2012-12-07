require 'contextio/api/resource'

class ContextIO
  class Message
    include ContextIO::API::Resource

    self.primary_key = :message_id
    self.association_name = :message

    has_many :sources
    belongs_to :account

    lazy_attributes :date, :folders, :addresses, :subject, 'list-help',
                    'list-unsubscribe', :message_id, :email_message_id,
                    :gmail_message_id, :gmail_thread_id, :person_info,
                    :date_received, :date_indexed
    private :date_received, :date_indexed

    def received_at
      @received_at ||= Time.at(date_received)
    end

    def indexed_at
      @indexed_at ||= Time.at(date_indexed)
    end
  end
end
