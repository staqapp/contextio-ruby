module ContextIO
  class Client
    get 'discovery', options: { source_type: 'imap' }

    get 'connect_tokens', as: :list_connect_tokens
    get 'connect_tokens/:token', as: :get_connect_tokens
    post 'connect_tokens', as: :add_connect_token, required: :callback_url
    delete 'connect_tokens/:token', as: :delete_connect_token

    get 'oatuh_providers', as: :list_oauth_providers
    get 'oauth_providers/:provider_consumer_key', as: :get_oauth_provider
    post 'oauth_providers', as: :add_oauth_provider, required: [:provider_consumer_key, :type, :provider_consumer_secret]
    delete 'oauth_providers/:provider_consumer_key', as: :delete_oauth_provider
  end
end
