require_relative 'api/resource_collection'
require_relative 'webhook'

class ContextIO
  class WebhookCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::Webhook
    self.association_name = :webhooks

    belongs_to :account
  end
end
