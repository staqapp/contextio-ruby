require 'contextio/api/resource'

require 'contextio/source_collection'

class ContextIO
  class Account
    include ContextIO::API::Resource

    self.primary_key = :id
    self.resource_url = :accounts

    has_many :sources, ContextIO::SourceCollection

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

    private

    # def update(attributes = {})
    #   attrs = {}

    #   attrs[:first_name] = attributes[:first_name] if attributes[:first_name]
    #   attrs[:last_name] = attributes[:last_name] if attributes[:last_name]

    #   return nil if attrs.empty?

    #   ContextIO::API.request(:post, url, attrs)['success']
    # end
  end
end
