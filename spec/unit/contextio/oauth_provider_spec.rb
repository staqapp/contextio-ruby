require 'spec_helper'
require 'contextio/oauth_provider'

describe ContextIO::OAuthProvider do
  let(:api) { double('API') }

  describe ".new" do
    subject { ContextIO::OAuthProvider.new(api, foo: 'bar', baz: 'bot') }

    it "takes an api handle" do
      expect(subject.api).to eq(api)
    end

    it "assigns instance variables for hash arguments" do
      expect(subject.instance_variable_get('@foo')).to eq('bar')
      expect(subject.instance_variable_get('@baz')).to eq('bot')
    end
  end
end
