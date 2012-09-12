class ContextIO
  class ConnectToken < APIResource
    extend ContextIO::APIResource::All
    extend ContextIO::APIResource::Fetch
    include ContextIO::APIResource::Delete

    def self.url
      'connect_tokens'
    end

    def self.new_redirect_url(callback_url, options = {})
      options.keep_if do |(key, value)|
        %w(service_level email first_name last_name).include?(key.to_s)
      end

      result_hash = ContextIO::API.request(:post, 'connect_tokens', options.merge('callback_url' => callback_url))

      return result_hash['browser_redirect_url']
    end

    attr_reader :token, :email, :created, :used, :callback_url,
                :service_level, :first_name, :last_name

    def primary_key
      token
    end

    def created_at
      @created_at ||= Time.at(created)
    end

    def account
      # lazily create an Account object.
    end
  end
end
