require 'spec_helper'
require 'contextio/api'

describe ContextIO::API do
  describe ".version" do
    subject { ContextIO::API }

    it "uses API version 2.0" do
      expect(subject.version).to eq('2.0')
    end
  end

  describe ".base_url" do
    subject { ContextIO::API }

    it "is https://api.context.io" do
      expect(subject.base_url).to eq('https://api.context.io')
    end
  end

  describe ".new" do
    subject { ContextIO::API.new('test_key', 'test_secret') }

    it "takes a key" do
      expect(subject.key).to eq('test_key')
    end

    it "takes a secret" do
      expect(subject.secret).to eq('test_secret')
    end
  end

  describe "#path" do
    context "without params" do
      subject { ContextIO::API.new(nil, nil).path('test_command') }

      it "puts the command in the path" do
        expect(subject).to eq('/2.0/test_command')
      end
    end

    context "with params" do
      subject { ContextIO::API.new(nil, nil).path('test_command', foo: 1, bar: %w(a b c)) }

      it "URL encodes the params" do
        expect(subject).to eq('/2.0/test_command?foo=1&bar=a%2Cb%2Cc')
      end
    end
  end

  describe "#request" do
    subject { ContextIO::API.new(nil, nil).request(:get, 'test') }

    context "with a good response" do
      before do
        FakeWeb.register_uri(
          :get,
          'https://api.context.io/2.0/test',
          body: JSON.dump('a' => 'b', 'c' => 'd')
        )
      end

      it "parses the JSON response" do
        expect(subject).to eq('a' => 'b', 'c' => 'd')
      end
    end

    context "with a bad response that has a body" do
      before do
        FakeWeb.register_uri(
          :get,
          'https://api.context.io/2.0/test',
          status: ['400', 'Bad Request'],
          body: JSON.dump('type' => 'error', 'value' => 'nope')
        )
      end

      it "raises an APIError with the body message" do
        expect { subject }.to raise_error(ContextIO::APIError, 'nope')
      end
    end

    context "with a bad response that has no body" do
      before do
        FakeWeb.register_uri(
          :get,
          'https://api.context.io/2.0/test',
          status: ['400', 'Bad Request']
        )
      end

      it "raises an APIError with the header message" do
        expect { subject }.to raise_error(ContextIO::APIError, 'Bad Request')
      end
    end
  end
end
