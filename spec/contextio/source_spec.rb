require 'spec_helper'
require 'contextio/source'

describe ContextIO::Source do
  let(:api) { double('api') }

  subject { ContextIO::Source.new(api, resource_url: 'resource url') }

  describe ".new" do
    context "with a label passed in" do
      it "doesn't raise an error" do
        expect { ContextIO::Source.new(api, label: '1234') }.to_not raise_error
      end
    end

    context "with neither a label nor a resource_url passed in" do
      it "raise an ArgumentError" do
        expect { ContextIO::Source.new(api, foo: 'bar') }.to raise_error(ArgumentError)
      end
    end
  end
end
