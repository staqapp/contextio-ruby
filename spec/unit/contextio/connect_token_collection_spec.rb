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

  describe "#create" do
    before do
      api.stub(:request).with(:post, anything, anything).and_return({ token: '1234' })
    end

    it "posts to /connect_tokens" do
      api.should_receive(:request).with(
        :post,
        'connect_tokens',
        callback_url: 'http://callback.com'
      )

      subject.create('http://callback.com')
    end

    it "doesn't make any more API calls than it needs to" do
      api.should_not_receive(:request).with(:get, anything, anything)

      subject.create('http://callback.com')
    end

    it "returns a ConnectToken" do
      expect(subject.create('http://callback.com')).to be_a(ContextIO::ConnectToken)
    end
  end
end
