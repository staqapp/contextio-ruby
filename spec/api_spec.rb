require 'spec_helper'
require 'contextio/api'

describe ContextIO::API do
  it "uses version 2.0 of the API" do
    expect(subject.version).to eq('2.0')
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

  %w(get delete put post).each do |http_method|
    describe ".#{http_method}" do
      let(:token) { double(:token) }

      it "delegates to the token passed in" do
        token.should_receive(http_method).with(anything, 'Accept' => 'application/json')
      end

      after do
        ContextIO::API.send(http_method, token, 'test_command')
      end
    end
  end
end
