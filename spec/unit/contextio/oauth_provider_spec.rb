require 'spec_helper'
require 'contextio/oauth_provider'

describe ContextIO::OAuthProvider do
  let(:api) { double('API') }

  describe ".new" do
    subject { ContextIO::OAuthProvider.new(api, resource_url: 'bar', baz: 'bot') }

    it "takes an api handle" do
      expect(subject.api).to eq(api)
    end

    it "assigns instance variables for hash arguments" do
      expect(subject.instance_variable_get('@resource_url')).to eq('bar')
      expect(subject.instance_variable_get('@baz')).to eq('bot')
    end

    context "with a provider_consumer_key passed in" do
      it "doesn't raise an error" do
        expect { ContextIO::OAuthProvider.new(api, provider_consumer_key: 'foo') }.to_not raise_error
      end
    end

    context "with a resource_url passed in" do
      it "doesn't raise an error" do
        expect { ContextIO::OAuthProvider.new(api, resource_url: 'foo') }.to_not raise_error
      end
    end

    context "with neither a provider_consumer_key nor a resource_url passed in" do
      it "raises an ArgumentError" do
        expect { ContextIO::OAuthProvider.new(api, foo: 'bar') }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#resource_url" do
    context "when input at creation" do
      subject { ContextIO::OAuthProvider.new(api, resource_url: 'http://example.com') }

      it "uses the input URL" do
        expect(subject.resource_url).to eq('http://example.com')
      end
    end

    context "when not input at creation" do
      subject { ContextIO::OAuthProvider.new(api, provider_consumer_key: '1234') }

      it "builds its own URL" do
        expect(subject.resource_url).to eq('oauth_providers/1234')
      end
    end
  end

  describe "#provider_consumer_key" do
    context "when input at creation" do
      subject { ContextIO::OAuthProvider.new(api, provider_consumer_key: '1234') }

      it "uses the input key" do
        api.should_not_receive(:request)

        expect(subject.provider_consumer_key).to eq('1234')
      end
    end

    context "when not input at creation" do
      subject { ContextIO::OAuthProvider.new(api, resource_url: 'http://example.com/hitme') }

      it "loads it from the API" do
        api.should_receive(:request).with(
          :get,
          'http://example.com/hitme'
        ).and_return({
          'provider_consumer_key' => 'baphoo'
        })

        expect(subject.provider_consumer_key).to eq('baphoo')
      end
    end
  end

  describe "#type" do
    context "when input at creation" do
      subject { ContextIO::OAuthProvider.new(api, provider_consumer_key: '1234', type: 'GMAIL') }

      it "uses the input type" do
        api.should_not_receive(:request)

        expect(subject.type).to eq('GMAIL')
      end
    end

    context "when not input at creation" do
      subject { ContextIO::OAuthProvider.new(api, provider_consumer_key: '1234') }

      it "loads it from the API" do
        api.should_receive(:request).with(:get, anything).and_return({ 'type' => 'GOOGLEAPPSMARKETPLACE' })
        expect(subject.type).to eq('GOOGLEAPPSMARKETPLACE')
      end
    end
  end

  describe "#fetch_attributes" do
    subject { ContextIO::OAuthProvider.new(api, provider_consumer_key: '1234') }

    before do
      api.stub(:request).with(:get, anything).and_return({ 'foo' => 'foo' })
    end

    it "defines a getter if one doesn't already exist" do
      subject.send(:fetch_attributes)

      expect(subject.foo).to eq('foo')
    end
  end
end
