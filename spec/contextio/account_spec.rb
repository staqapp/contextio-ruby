require 'spec_helper'
require 'contextio/account'

describe ContextIO::Account do
  let(:api) { double('api', url_for: 'url from api') }

  subject { ContextIO::Account.new(api, id: '1234') }

  describe ".new" do
    context "with an id passed in" do
      it "doesn't raise an error" do
        expect { ContextIO::Account.new(api, id: '1234') }.to_not raise_error
      end
    end

    context "with neither an id nor a resource_url passed in" do
      it "raises an ArgumentError" do
        expect { ContextIO::Account.new(api, foo: 'bar') }.to raise_error(ArgumentError)
      end
    end
  end

  it "has sources as an association" do
    api.stub(:request).and_return('sources' => [{'foo' => 'bar'}])

    expect(subject.sources).to be_a(ContextIO::SourceCollection)
  end

  it "has connect tokens as an association" do
    api.stub(:request).and_return('connect_tokens' => [{'foo' => 'bar'}])

    expect(subject.connect_tokens).to be_a(ContextIO::ConnectTokenCollection)
  end
end
