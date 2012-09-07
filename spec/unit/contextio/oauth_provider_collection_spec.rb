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
  end
end
