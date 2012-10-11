require 'contextio/api/resource'

class ContextIO
  class Account
    include ContextIO::API::Resource

    self.primary_key = :id

    private

    # Builds the path that will fetch the attributes for this account.
    #
    # @return [String] The path of the resource.
    def build_resource_url
      "accounts/#{id}"
    end

    # def self.url
    #   'accounts'
    # end

    # def self.create(email, options={})
    #   result_hash = ContextIO::API.request(:post, url, email: email, first_name: options[:first_name], last_name: options[:last_name])

    #   fetch(result_hash['id'])
    # end

    # attr_reader :id, :username, :created, :suspended, :email_addresses,
    #             :first_name, :last_name, :password_expired, :sources,
    #             :nb_messages, :nb_files

    # def primary_key
    #   id
    # end

    # def update(attributes = {})
    #   attrs = {}

    #   attrs[:first_name] = attributes[:first_name] if attributes[:first_name]
    #   attrs[:last_name] = attributes[:last_name] if attributes[:last_name]

    #   return nil if attrs.empty?

    #   ContextIO::API.request(:post, url, attrs)['success']
    # end

    # def created_at
    #   Time.at(created) if created
    # end

    # def suspended_at
    #   Time.at(suspended) if suspended_at
    # end

    # def suspended?
    #   !!suspended
    # end

    # def password_expired_at
    #   Time.at(password_expired) if password_expired
    # end

    # def password_expired?
    #   !!password_expired
    # end
  end
end
