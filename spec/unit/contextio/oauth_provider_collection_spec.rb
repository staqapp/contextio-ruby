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
      api.stub(:request).with(:post, anything, anything).and_return({ provider_consumer_key: 'test_key' })
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

  describe "#each" do
    let(:response) do
      [
        {
          'type' => 'GMAIL',
          'provider_consumer_key' => 'test_key_1',
          'provider_consumer_secret' => 'test_secret_1'
        },
        {
          'type' => 'GMAIL',
          'provider_consumer_key' => 'test_key_2',
          'provider_consumer_secret' => 'test_secret_2'
        }
      ]
    end

    before do
      api.stub(:request).with(:get, 'oauth_providers').and_return(response)
    end

    it "gets to /oauth_providers" do
      api.should_receive(:request).with(:get, 'oauth_providers').and_return(response)

      subject.each {}
    end

    it "yields OAuthProviders based on the response" do
      subject.each do |x|
        expect(x).to be_a(ContextIO::OAuthProvider)
      end
    end

    it "passes the attributes to the OAuthProvider" do
      ContextIO::OAuthProvider.should_receive(:new).with(
        api,
        'type' => 'GMAIL',
        'provider_consumer_key' => 'test_key_1',
        'provider_consumer_secret' => 'test_secret_1'
      )
      ContextIO::OAuthProvider.should_receive(:new).with(
        api,
        'type' => 'GMAIL',
        'provider_consumer_key' => 'test_key_2',
        'provider_consumer_secret' => 'test_secret_2'
      )

      subject.each {}
    end
  end
end
