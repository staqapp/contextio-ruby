module ContextIO
  class EmailSettings < APIResource
    def self.discover_for(email_address, source_type = 'imap')
      attrs = ContextIO::API.request(:get, 'discovery', email: email_address, source_type: source_type)
      new(attrs)
    end

    attr_reader :email, :found, :type, :documentation, :imap

    def found?
      !!found
    end

    def server
      imap['server']
    end

    def username
      imap['username']
    end

    def port
      imap['port']
    end

    def oauth?
      !!imap['oauth']
    end

    def uses_ssl?
      !!imap['use_ssl']
    end
  end
end
