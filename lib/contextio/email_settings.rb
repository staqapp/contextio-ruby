module ContextIO
  class EmailSettings < APIResource
    def self.discover_for(email_address, source_type = 'imap')
      attrs = ContextIO::API.request(:get, 'discovery', email_address: email_address, source_type: source_type)
      new(attrs)
    end

    attr_reader :email, :found, :type, :documentation, :imap
  end
end
