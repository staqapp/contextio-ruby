require 'contextio/api/resource'

class ContextIO
  class Contact
    include ContextIO::API::Resource

    self.primary_key = :email
    self.association_name = :contact

    belongs_to :account

    lazy_attributes :emails, :name, :thumbnail, :last_received, :last_sent,
                    :count
    private :last_received, :last_sent

    def email
      @email ||= emails.first
    end

    def last_received_at
      last_received ? Time.at(last_received) : nil
    end

    def last_sent_at
      last_sent ? Time.at(last_sent) : nil
    end
  end
end
