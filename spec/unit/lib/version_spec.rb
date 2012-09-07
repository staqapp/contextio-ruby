require 'spec_helper'
require 'contextio'

describe ContextIO do
  describe ".version" do
    it "reports its version" do
      expect(ContextIO.version).to_not be_empty
    end
  end

  describe "#version" do
    it "reports its version" do
      expect(subject.version).to_not be_empty
    end
  end
end
