require 'uri'
require 'oauth'
require 'json'

class ContextIO
  class API
    attr_reader :key, :secret

    def initialize(key, secret)
      @key = key
      @secret = secret
    end
  end

  module BS
    @@version = '2.0'
    @@key = nil
    @@secret = nil
    @@base_url = 'https://api.context.io'

    @@consumer = nil
    @@token = nil

    def self.version
      @@version
    end

    def self.version=(version)
      @@version = version
    end

    def self.key
      @@key
    end

    def self.key=(key)
      @@key = key
    end

    def self.secret
      @@secret
    end

    def self.secret=(secret)
      @@secret = secret
    end

    def self.base_url
      @@base_url
    end

    def self.base_url=(base_url)
      @@base_url = base_url
    end

    def self.consumer
      unless @@consumer || (key && secret)
        raise ContextIO::ConfigurationError, 'You must provide a key and a secret. Assign them with "ContextIO::API.key = <KEY>" and "ContextIO::API.secret = <SECRET>".'
      end

      @@consumer ||= OAuth::Consumer.new(key, secret, site: base_url)
    end

    def self.token
      @@token ||= OAuth::AccessToken.new(consumer)
    end

    def self.request(method, command, params = {})
      response = token.send(method, path(command, params), 'Accept' => 'application/json')
      body = response.body

      results = JSON.parse(body)

      if response.code =~ /[45]\d\d/
        if results.is_a?(Hash) && results['type'] == 'error'
          message = results['value']
        else
          message = response.message
        end

        raise APIError, message
      end

      results
    end

    private

    def self.path(command, params = {})
      path = "/#{ContextIO::API.version}/#{command}"

      unless params.empty?
        path << "?#{paramaterize(params)}"
      end

      path
    end

    def self.paramaterize(params)
      params = params.inject({}) do |memo, (k, v)|
        memo[k] = Array(v).join(',')

        memo
      end

      URI.encode_www_form(params)
    end
  end
end
