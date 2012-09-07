require 'spec_helper'
require 'contextio/oauth_provider_collection'

describe ContextIO::OAuthProviderCollection do
  let(:api) { double('API') }

  describe ".new" do
    subject { ContextIO::OAuthProviderCollection.new(api) }

    it "takes an api handle" do
      expect(subject.api).to eq(api)
    end
  end
end
