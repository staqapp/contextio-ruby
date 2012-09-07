require 'spec_helper'
require 'contextio/api'

describe ContextIO::API do
  describe ".version" do
    subject { ContextIO::API }

    it "uses API version 2.0" do
      expect(subject.version).to eq('2.0')
    end
  end

  describe ".path" do
    context "without params" do
      subject { ContextIO::API.path('test_command') }

      it "puts the command in the path" do
        expect(subject).to eq('/2.0/test_command')
      end
    end

    context "with params" do
      subject { ContextIO::API.path('test_command', foo: 1, bar: %w(a b c)) }

      it "URL encodes the params" do
        expect(subject).to eq('/2.0/test_command?foo=1&bar=a%2Cb%2Cc')
      end
    end
  end

  describe ".request" do
    let(:http_response) { double(:http_response, :body => JSON.dump('a' => 'b', 'c' => 'd')) }
    let(:token) { double(:token, :get => http_response) }

    before do
      ContextIO::API.stub(:token) { token }
    end

    it "delegates to the token passed in" do
      token.should_receive(:get).with(anything, 'Accept' => 'application/json')
      ContextIO::API.request(:get, 'test_command')
    end

    it "parses the JSON response" do
      r = ContextIO::API.request(:get, 'test_command')
      expect(r).to eq('a' => 'b', 'c' => 'd')
    end
  end
end
