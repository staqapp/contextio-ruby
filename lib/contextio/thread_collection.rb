require_relative 'api/resource_collection'
require_relative 'thread'

class ContextIO
  class ThreadCollection
    include ContextIO::API::ResourceCollection

    self.resource_class = ContextIO::Thread
    self.association_name = :threads

    belongs_to :account

    # Iterates over the resources in question.
    #
    # @example
    #   contextio.connect_tokens.each do |connect_token|
    #     puts connect_token.email
    #   end
    def each(&block)
      attribute_hashes.each do |actually_a_resource_url|
        yield resource_class.new(api, {resource_url: actually_a_resource_url}.merge(associations_hash))
      end
    end
  end
end
