require 'spec_helper'
require 'contextio/connect_token_collection'

describe ContextIO::ConnectTokenCollection do
  let(:api) { double('API') }

  subject { ContextIO::ConnectTokenCollection.new(api) }

  describe ".new" do
    it "takes an api handle" do
      expect(subject.api).to eq(api)
    end
  end
end
