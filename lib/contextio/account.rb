require 'contextio/api/resource'

class ContextIO
  class Account
    include ContextIO::API::Resource

    self.primary_key = :id
    self.association_name = :account

    has_many :sources
    has_many :connect_tokens
    has_many :messages
    has_many :threads

    # @!attribute [r] id
    #   @return [String] The id assigned to this account by Context.IO.
    # @!attribute [r] username
    #   @return [String] The username assigned to this account by Context.IO.
    # @!attribute [r] email_addresses
    #   @return [Array<String] The email addresses associated with this account.
    # @!attribute [r] first_name
    #   @return [String] The account holder's first name.
    # @!attribute [r] last_name
    #   @return [String] The account holder's last name.
    lazy_attributes :id, :username, :created, :suspended, :email_addresses,
                    :first_name, :last_name, :password_expired, :nb_messages,
                    :nb_files
    private :created, :suspended, :password_expired

    # @!attribute [r] created_at
    #   @return [Time] The time this account was created (with Context.IO).
    def created_at
      @created_at ||= Time.at(created)
    end

    # @!attribute [r] suspended_at
    #   @return [Time] The time this account was suspended.
    def suspended_at
      return @suspended_at if instance_variable_defined?(:@suspended_at)

      @suspended_at = suspended == 0 ? nil : Time.at(suspended)

      @suspended_at
    end

    # @!attribute [r] suspended?
    #   @return [Boolean] Whether this account is currently suspended.
    def suspended?
      !!suspended_at
    end

    # @!attribute [r] password_expired_at
    #   @return [Time] The time this account's password expired.
    def password_expired_at
      return @password_expired_at if instance_variable_defined?(:@password_expired_at)

      @password_expired_at = password_expired == 0 ? nil : Time.at(password_expired)

      @password_expired_at
    end

    # @!attribute [r] password_expired?
    #   @return [Boolean] Whether this account's password is expired.
    def password_expired?
      !!password_expired_at
    end

    # Updates the account.
    #
    # @param [Hash{String, Symbol => String}] options You can update first_name
    #   or last_name (or both).
    def update(options={})
      first_name = options[:first_name] || options['first_name']
      last_name = options[:last_name] || options['last_name']

      attrs = {}
      attrs[:first_name] = first_name if first_name
      attrs[:last_name] = last_name if last_name

      return nil if attrs.empty?

      it_worked = api.request(:post, resource_url, attrs)['success']

      if it_worked
        @first_name = first_name || @first_name
        @last_name = last_name || @last_name
      end

      it_worked
    end
  end
end
