class ContextIO
  # Represents a single connect token for an account. You can use this to
  # inspect or delete the token. Most of the attributes are lazily loaded,
  # meaning that the API won't get hit until you ask for an attribute the object
  # doesn't already have (presumably from a previous API call).
  class ConnectToken
    # (see ContextIO#api)
    attr_reader :api

    # (see ContextIO::OAuthProviderCollection#initialize)
    def initialize(api, options = {})
      required_options = [:token, 'token', :resource_url, 'resource_url']

      if (options.keys & required_options).empty?
        raise ArgumentError, 'Either a token or a resource_url is required'
      end

      @api = api

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    private

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
