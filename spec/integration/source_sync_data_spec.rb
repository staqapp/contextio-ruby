require 'contextio'

describe "Syncing data for a source" do
  let(:api) { double(:api) }
  subject { ContextIO::Source.new(api, resource_url: 'resource url') }

  before do
    allow(api).to receive(:request).and_return({foo: 'bar'})
  end

  it "initializes a SourceSyncData correctly" do
    expect { subject.sync_data }.to_not raise_exception
  end
end
