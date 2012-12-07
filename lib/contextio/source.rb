require 'contextio/api/resource'

class ContextIO
  class Source
    include ContextIO::API::Resource

    self.primary_key = :label
    self.association_name = :source

    belongs_to :account

    lazy_attributes :server, :label, :username, :port, :authentication_type,
                    :status, :service_level, :sync_period, :use_ssl, :type
    private :use_ssl

    # @!attribute [r] use_ssl?
    #   @return [Boolean] Whether or not this source uses SSL.
    def use_ssl?
      use_ssl
    end

    # Updates the source.
    #
    # @params [Hash{String, Symbol => String}] options You can update the
    #   following: status, sync_period, service_level, password, provider_token,
    #   provider_token_secret, provider_consumer_key. See the Context.IO docs
    #   for more details on these fields.
    def update(options={})
      status                = options[:status] || options['status']
      sync_period           = options[:sync_period] || options['sync_period']
      service_level         = options[:service_level] || options['service_level']
      password              = options[:password] || options['password']
      provider_token        = options[:provider_token] || options['provider_token']
      provider_token_secret = options[:provider_token_secret] || options['provider_token_secret']
      provider_consumer_key = options[:provider_consumer_key] || options['provider_consumer_key']

      attrs = {}
      attrs[:status]                = status if status
      attrs[:sync_period]           = sync_period if sync_period
      attrs[:service_level]         = service_level if service_level
      attrs[:password]              = password if password
      attrs[:provider_token]        = provider_token if provider_token
      attrs[:provider_token_secret] = provider_token_secret if provider_token_secret
      attrs[:provider_consumer_key] = provider_consumer_key if provider_consumer_key

      return nil if attrs.empty?

      it_worked = api.request(:post, resource_url, attrs)['success']

      if it_worked
        @status                = status || @status
        @sync_period           = sync_period || @sync_period
        @service_level         = service_level || @service_level
        @password              = password || @password
        @provider_token        = provider_token || @provider_token
        @provider_token_secret = provider_token_secret || @provider_token_secret
        @provider_consumer_key = provider_consumer_key || @provider_consumer_key
      end

      it_worked
    end
  end
end
