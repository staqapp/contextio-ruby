require 'uri'
require 'oauth'
require 'json'
require_relative 'errors'

class ContextIO
  class API
    VERSION = '2.0'

    def self.version
      VERSION
    end

    BASE_URL = 'https://api.context.io'

    def self.base_url
      BASE_URL
    end

    attr_reader :key, :secret

    def initialize(key, secret)
      @key = key
      @secret = secret
    end

    def path(command, params = {})
      "/#{ContextIO::API.version}/#{command.to_s}#{ContextIO::API.hash_to_url_params(params)}"
    end

    def request(method, command, params = {})
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

    def self.hash_to_url_params(params = {})
      return '' if params.empty?

      params = params.inject({}) do |memo, (k, v)|
        memo[k] = Array(v).join(',')

        memo
      end

      "?#{URI.encode_www_form(params)}"
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(key, secret, site: ContextIO::API.base_url)
    end

    def token
      @token ||= OAuth::AccessToken.new(consumer)
    end
  end
end
