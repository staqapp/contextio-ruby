require 'spec_helper'
require 'contextio/api/resource_initializer'

describe ContextIO::API::ResourceInitializer do
  let(:helper_class) do
    Class.new do
      include ContextIO::API::ResourceInitializer

      def required_options
        ['string', :symbol]
      end
    end
  end

  subject { helper_class.new }

  describe "#validate_required_options" do
    it "matches strings to symbols" do
      expect { subject.send(:validate_required_options, 'symbol' => 'foo') }.to_not raise_error
    end

    it "matches symbols to strings" do
      expect { subject.send(:validate_required_options, string: 'foo') }.to_not raise_error
    end

    it "matches strings to strings" do
      expect { subject.send(:validate_required_options, 'string' => 'foo') }.to_not raise_error
    end

    it "matches symbols to symbols" do
      expect { subject.send(:validate_required_options,  symbol: 'bar') }.to_not raise_error
    end

    it "raises with missing keys" do
      expect { subject.send(:validate_required_options, foo: 'bar') }.to raise_error
    end
  end
end
