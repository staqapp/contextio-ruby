require 'spec_helper'
require 'contextio/account_collection'

describe ContextIO::AccountCollection do
  let(:api) { double('API') }

  subject { ContextIO::AccountCollection.new(api) }

  describe ".new" do
    it "takes an api handle" do
      expect(subject.api).to eq(api)
    end
  end
end
