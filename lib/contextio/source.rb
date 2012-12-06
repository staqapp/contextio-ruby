require 'contextio/api/resource'

class ContextIO
  class Source
    include ContextIO::API::Resource

    self.primary_key = :label
    self.association_name = :source

    lazy_attributes :server, :label, :username, :port, :authentication_type,
                    :status, :service_level, :sync_period, :use_ssl, :type
    private :use_ssl

    # @!attribute [r] use_ssl?
    #   @return [Boolean] Whether or not this source uses SSL.
    def use_ssl?
      use_ssl
    end
  end
end
