require 'contextio/api/resource'

class ContextIO
  # Represents a single connect token for an account. You can use this to
  # inspect or delete the token. Most of the attributes are lazily loaded,
  # meaning that the API won't get hit until you ask for an attribute the object
  # doesn't already have (presumably from a previous API call).
  class ConnectToken
    include API::Resource

    # @!attribute [r] token
    #   @return [String] The token associated with this connect token.
    lazy_attributes :token

    required_options :token

    # (see ContextIO::OAuthProviderCollection#initialize)
    def initialize(api, options = {})
      validate_required_options(options)

      @api = api

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # @!attribute [r] resource_url
    # @return [String] The URL that will fetch attributes from the API.
    def resource_url
      @resource_url ||= build_resource_url
    end

    private

    # Builds the path that will fetch the attributes for this provider.
    #
    # @return [String] The path of the resource.
    def build_resource_url
      "connect_tokens/#{token}"
    end

    # attr_reader :token, :email, :created, :used, :callback_url,
    #             :service_level, :first_name, :last_name

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
