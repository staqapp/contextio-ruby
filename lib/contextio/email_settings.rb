require 'contextio/api/lazy_attributes'

class ContextIO
  # Represents the IMAP settings for a given email address. The API
  # documentation refers to this as 'discovery'. This process is hit-and-miss.
  # If noting is found, many attributes are likely to be nil and blank. Check
  # {EmailSettings#found? EmailSettings#found?}.
  class EmailSettings
    extend API::LazyAttributes

    # (see ContextIO#api)
    attr_reader :api

    # @!attribute [r] found
    #   @return [Boolean] Whether the settings were able to be fetched. Will
    #     fetch from the API if necessary.
    # @!attribute [r] type
    #   @return [String] The type og the provider (like 'gmail'). Will fetch
    #     from the API if necessary.
    # @!attribute [r] documentation
    #   @return [Array<String>] A list of documentation pages that pertain to
    #     the provider. Will fetch from the API if necessary.
    lazy_attributes :found, :type, :documentation, :imap
    private :imap

    # @!attribute [r] email
    #   @return [String] The email address associated with these IMAP settings.
    # @!attribute [r] source_type
    #   @return [String] The only source type currently supported by the API is
    #     'IMAP'.
    attr_reader :email, :source_type

    # (see ContextIO::OAuthProviderCollection#initialize)
    # @param [String] email The email address to fetch the settings for.
    # @param [String] source_type The only source type currently supported by
    #   the API is 'IMAP'.
    def initialize(api, email, source_type = 'IMAP')
      @api = api
      @email = email
      @source_type = source_type
    end

    # @!attribute [r] resource_url
    # @return [String] The path for discovering email settings.
    def resource_url
      'discovery'
    end

    private

    # Fetches attributes from the API for the email settings.
    #
    # Defines getter methods for any attributes that come back and don't
    # already have them. This way, if the API expands, the gem will still let
    # users get attributes we didn't explicitly declare as lazy.
    def fetch_attributes
      attr_hashes = api.request(:get, resource_url, 'email' => email, 'source_type' => source_type)

      attr_hashes.each do |key, value|
        instance_variable_set("@#{key}", value)

        unless respond_to?(key)
          instance_eval <<-RUBY
            def #{key}
              @#{key}
            end
          RUBY
        end
      end
    end







    def self.discover_for(email_address, source_type = 'IMAP')
      attrs = ContextIO::API.request(:get, 'discovery', email: email_address, source_type: source_type)
      new(attrs)
    end

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
