require 'spec_helper'
require 'contextio/api'

describe ContextIO::API do
  it "uses version 2.0 of the API" do
    expect(subject.version).to eq('2.0')
  end
end
