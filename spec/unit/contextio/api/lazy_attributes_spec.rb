require 'spec_helper'
require 'contextio/api/lazy_attributes'

describe ContextIO::API::LazyAttributes do
  let(:helper_class) do
    Class.new do
      extend ContextIO::API::LazyAttributes

      lazy_attributes :foo

      def fetch_attributes
        @foo = 'set from API'
      end
    end
  end

  subject { helper_class.new }

  it "defines a method for the attribute" do
    expect(subject).to respond_to(:foo)
  end

  context "when the instance variable is set" do
    before do
      subject.instance_variable_set(:@foo, 'set into instance variable')
    end

    it "returns the value set" do
      expect(subject.foo).to eq('set into instance variable')
    end

    it "doesn't try to fetch from the API" do
      subject.should_not_receive(:fetch_attributes)

      subject.foo
    end
  end

  context "when the instance variable is not set" do
    it "tries to fetch from the API" do
      subject.should_receive(:fetch_attributes)

      subject.foo
    end

    it "returns the value from the API" do
      expect(subject.foo).to eq('set from API')
    end
  end
end
