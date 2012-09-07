require 'spec_helper'
require 'contextio/oauth_provider_collection'

describe ContextIO::OAuthProviderCollection do
  let(:api) { double('API') }

  subject { ContextIO::OAuthProviderCollection.new(api) }

  describe ".new" do
    it "takes an api handle" do
      expect(subject.api).to eq(api)
    end
  end

  describe "#create" do
    before do
      api.stub(:request).with(:post, anything, anything).and_return({})
    end

    it "posts to /oauth_providers" do
      api.should_receive(:request).with(
        :post,
        'oauth_providers',
        type: 'GMAIL',
        provider_consumer_key: 'test_key',
        provider_consumer_secret: 'test_secret'
      )

      subject.create('GMAIL', 'test_key', 'test_secret')
    end

    it "doesn't make any more API requests than it needs to" do
      api.should_not_receive(:request).with(:get, anything)

      subject.create('GMAIL', 'test_key', 'test_secret')
    end

    it "returns an OAuthProvider" do
      expect(subject.create('GMAIL', 'test_key', 'test_secret')).to be_a(ContextIO::OAuthProvider)
    end
  end
end
