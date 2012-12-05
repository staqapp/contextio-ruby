require 'spec_helper'
require 'contextio/api/resource_helpers'

describe ContextIO::API::ResourceHelpers do
  subject { ContextIO::API::ResourceHelpers }

  describe ".class_to_association_name" do
    it "strips off leading name spaces" do
      expect(subject.class_to_association_name('Foo::Bar::Baz')).to eq('baz')
    end

    it "handles snake casing" do
      expect(subject.class_to_association_name('ConnectToken')).to eq('connect_token')
    end

    it "pluralizes collections" do
      expect(subject.class_to_association_name('MessageCollection')).to eq('messages')
    end
  end
end
