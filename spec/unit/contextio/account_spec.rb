require 'spec_helper'
require 'contextio/account'

describe ContextIO::Account do
  let(:api) { double('api') }

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
end
