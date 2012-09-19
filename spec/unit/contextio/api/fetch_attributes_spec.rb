require 'spec_helper'
require 'contextio/api/fetch_attributes'

describe ContextIO::API::FetchAttributes do
  let(:helper_class) do
    Class.new do
      include ContextIO::API::FetchAttributes

      def resource_url
        'resource_url'
      end
    end
  end

  subject do
    helper_class.new.tap do |s|
      s.stub(:api).and_return(double('API'))
    end
  end

  describe "#fetch_attributes" do
    it "makes a request to the API" do
      subject.api.should_receive(:request).with(:get, 'resource_url').and_return({})

      subject.send(:fetch_attributes)
    end

    it "defines getter methods for new attributes returned" do
      subject.api.stub(:request).and_return(:foo => 'bar')

      subject.send(:fetch_attributes)

      expect(subject.foo).to eq('bar')
    end

    it "sets an instance variable from the attribute" do
      subject.api.stub(:request).and_return(:foo => 'bar')

      subject.send(:fetch_attributes)

      expect(subject.instance_variable_get('@foo')).to eq('bar')
    end

    it "doesn't override existing getter methods" do
      def subject.foo
        'hard coded value'
      end

      subject.api.stub(:request).and_return(:foo => 'bar')

      subject.send(:fetch_attributes)

      expect(subject.foo).to eq('hard coded value')
    end
  end
end
