require 'uri'

module ContextIO
  module API
    VERSION = '2.0'

    def self.version
      VERSION
    end

    def self.path(command, params = {})
      path = "/#{ContextIO::API.version}/#{command}"

      unless params.empty?
        path << "?#{paramaterize(params)}"
      end

      path
    end

    def self.paramaterize(params)
      URI.encode_www_form(params)
    end
  end
end
