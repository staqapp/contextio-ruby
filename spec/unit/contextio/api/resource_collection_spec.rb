require 'spec_helper'
require 'contextio/api/resource_collection'

class SingularHelper
  def initialize(*args); end
  def self.primary_key; 'token'; end
end

describe ContextIO::API::ResourceCollection do
  let(:api) do
    double('api')
  end

  describe ".resource_class" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::ResourceCollection

        resource_class SingularHelper
      end
    end

    subject do
      helper_class.new(api)
    end

    it "makes the class available to instances of the collection" do
      expect(subject.resource_class).to eq(SingularHelper)
    end
  end

  describe ".resource_url" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::ResourceCollection

        resource_url 'helper_class'
      end
    end

    subject do
      helper_class.new(api)
    end

    it "makes the url available to instances of the collection" do
      expect(subject.resource_url).to eq('helper_class')
    end
  end

  describe "#api" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::ResourceCollection
      end
    end

    subject do
      helper_class.new(api)
    end

    it "holds a reference to the api" do
      expect(subject.api).to eq(api)
    end
  end

  describe "#each" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::ResourceCollection

        resource_url 'url'
        resource_class SingularHelper
      end
    end

    subject do
      helper_class.new(api)
    end

    before do
      api.stub(:request).and_return([{key: 'value 1'}, {key: 'value 2'}])
    end

    it "yields instances of the singular resource class" do
      subject.each do |x|
        expect(x).to be_a(SingularHelper)
      end
    end

    it "gets attributes for the resources from the api" do
      api.should_receive(:request).exactly(:once).with(:get, 'url')

      subject.each { }
    end

    it "passes the api to the singular resource instances" do
      SingularHelper.should_receive(:new).exactly(:twice).with(api, anything)

      subject.each { }
    end

    it "passes attributes to the singular resource instances" do
      SingularHelper.should_receive(:new).exactly(:once).with(anything, key: 'value 1')
      SingularHelper.should_receive(:new).exactly(:once).with(anything, key: 'value 2')

      subject.each { }
    end
  end

  describe "#[]" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::ResourceCollection

        resource_url 'url'
        resource_class SingularHelper
      end
    end

    subject do
      helper_class.new(api)
    end

    it "returns a new instance of the resource class" do
      expect(subject[1234]).to be_a(SingularHelper)
    end

    it "feeds the given key to the resource class" do
      SingularHelper.should_receive(:new).with(anything, 'token' => 1234)

      subject[1234]
    end

    it "feeds the api to the resource class" do
      SingularHelper.should_receive(:new).with(api, anything)

      subject[1234]
    end

    it "doesn't hit the API" do
      api.should_not_receive(:request)

      subject[1234]
    end
  end
end
