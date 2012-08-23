module ContextIO
  class ConnectToken < APIResource
    def self.all
      attr_hashes = ContextIO::API.request(:get, 'connect_tokens')

      attr_hashes.map do |attr_hash|
        new(attr_hash)
      end
    end

    def self.new_redirect_url(callback_url, options = {})
      options.keep_if do |(key, value)|
        %w(service_level email first_name last_name).include?(key.to_s)
      end

      result_hash = ContextIO::API.request(:post, 'connect_tokens', options.merge('callback_url' => callback_url))

      return result_hash['browser_redirect_url']
    end

    def self.fetch(token)
      attr_hash = ContextIO::API.request(:get, "connect_tokens/#{token}")
      new(attr_hash)
    end

    attr_reader :token, :email, :created, :used, :callback_url,
                :service_level, :first_name, :last_name

    def delete
      ContextIO::API.request(:delete, "connect_tokens/#{token}")['success']
    end

    def created_at
      @created_at ||= Time.at(created)
    end

    def account
      # lazily create an Account object.
    end
  end
end
