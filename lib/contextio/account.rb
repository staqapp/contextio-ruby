module ContextIO
  class Account < APIResource
    extend ContextIO::APIResource::All
    extend ContextIO::APIResource::Fetch
    include ContextIO::APIResource::Delete

    def self.url
      'accounts'
    end

    def self.create(email, options={})
      result_hash = ContextIO::API.request(:post, url, email: email, first_name: options[:first_name], last_name: options[:last_name])

      fetch(result_hash['id'])
    end

    attr_reader :id, :username, :created, :suspended, :email_addresses,
                :first_name, :last_name, :password_expired, :sources,
                :nb_messages, :nb_files

    def primary_key
      id
    end

    def created_at
      Time.at(created) if created
    end

    def suspended_at
      Time.at(suspended) if suspended_at
    end

    def suspended?
      !!suspended
    end

    def password_expired_at
      Time.at(password_expired) if password_expired
    end

    def password_expired?
      !!password_expired
    end
  end
end
