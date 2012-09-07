require 'spec_helper'
require 'contextio'

describe ContextIO, :focus do
  describe ".new" do
    it "creates a new API handle" do
      expect(ContextIO.new('1234', '0987').api).to be_a(ContextIO::API)
    end

    it "passes credentials to its API handle" do
      api = ContextIO.new('1234', '0987').api
      expect(api.key).to eq('1234')
      expect(api.secret).to eq('0987')
    end
  end
end
