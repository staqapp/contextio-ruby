require 'contextio/api/resource'

class ContextIO
  class Thread
    include ContextIO::API::Resource

    self.primary_key = :gmail_thread_id
    self.association_name = :thread

    belongs_to :account
    has_many :messages

    lazy_attributes :gmail_thread_id, :email_message_ids, :person_info
  end
end
