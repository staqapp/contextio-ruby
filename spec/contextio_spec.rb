require 'spec_helper'
require 'contextio'

describe Contextio do
  it "reports its version" do
    expect(subject.version).to_not be_empty
  end
end
