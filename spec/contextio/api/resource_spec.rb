require 'spec_helper'
require 'contextio/api/resource'

class RelationHelper
  def initialize(*args); end
end

class RelationCollectionHelper
  def initialize(*args); end
end

describe ContextIO::API::Resource do
  let(:api) { double('api') }

  describe ".new" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::Resource

        self.primary_key = :foo

        def foo
          'defined in class'
        end
      end
    end

    subject { helper_class.new(api, foo: 'defined in method call', bar: 'baz') }

    it "defines accessors for options passed in" do
      expect(subject.bar).to eq('baz')
    end

    it "doesn't over-write accessors that already exist" do
      expect(subject.foo).to eq('defined in class')
    end
  end

  describe "#validate_options" do
    context "with a string primary key" do
      subject do
        Class.new do
          include ContextIO::API::Resource

          self.primary_key = 'string'
        end
      end

      it "matches a symbol" do
        expect { subject.new(api, string: 'foo') }.to_not raise_error
      end

      it "matches a string" do
        expect { subject.new(api, 'string' => 'foo') }.to_not raise_error
      end

      it "raises with missing keys" do
        expect { subject.new(api, foo: 'bar') }.to raise_error
      end

      it "doesn't raise if resource_url is set" do
        expect { subject.new(api, resource_url: 'some url') }.to_not raise_error
      end
    end

    context "with a symbol primary key"
      subject do
        Class.new do
          include ContextIO::API::Resource

          self.primary_key = :symbol
        end
      end

      it "matches a string" do
        expect { subject.new(api, 'symbol' => 'foo') }.to_not raise_error
      end

      it "matches a symbol" do
        expect { subject.new(api,  symbol: 'bar') }.to_not raise_error
      end

      it "raises with missing keys" do
        expect { subject.new(api, foo: 'bar') }.to raise_error
      end

      it "doesn't raise if resource_url is set" do
        expect { subject.new(api, resource_url: 'some url') }.to_not raise_error
      end
  end

  describe ".lazy_attributes" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::Resource

        lazy_attributes :foo
      end
    end

    let(:api) do
      double('api', request: {'foo' => 'set from API'})
    end

    subject { helper_class.new(api, resource_url: 'resource_url') }

    it "defines a method for the attribute" do
      expect(subject).to respond_to(:foo)
    end

    context "when the attribute is set at creation" do
      subject do
        helper_class.new(api, resource_url: 'resource_url', foo: 'foo')
      end

      it "returns the value set" do
        expect(subject.foo).to eq('foo')
      end

      it "doesn't try to fetch from the API" do
        subject.should_not_receive(:fetch_attributes)

        subject.foo
      end
    end

    context "when the attributes is not set at creation" do
      it "tries to fetch from the API" do
        api.should_receive(:request).with(:get, 'resource_url').
          and_return({'foo' => 'set from API'})

        subject.foo
      end

      it "returns the value from the API" do
        expect(subject.foo).to eq('set from API')
      end
    end
  end

  describe ".belongs_to" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::Resource

        belongs_to :relation, RelationHelper
      end
    end

    context "when one isn't passed in at creation" do
      subject { helper_class.new(api, resource_url: 'resource_url') }

      before do
        api.stub(:request).and_return(
          {
            'relation' => {
              'resource_url' => 'relation_url'
            }
          }
        )
      end

      it "makes a related object available" do
        expect(subject.relation).to be_a(RelationHelper)
      end

      it "passes keys from the api response to the new object" do
        RelationHelper.should_receive(:new).with(api, 'resource_url' => 'relation_url')

        subject.relation
      end

      it "returns the same object each time" do
        expect(subject.relation).to be(subject.relation)
      end
    end

    context "when one is passed in at creation" do
      let(:relation_object) { RelationHelper.new(api, resource_url: 'relation_url') }

      subject { helper_class.new(api, resource_url: 'resource_url', relation: relation_object)}

      it "makes the passed-in related object available" do
        expect(subject.relation).to be(relation_object)
      end

      it "doesn't make any API calls" do
        api.should_not_receive(:request)

        subject.relation
      end
    end
  end

  describe ".has_many" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::Resource

        has_many :relations, RelationCollectionHelper
      end
    end

    context "when a collection isn't passed in at creation" do
      context "and a collection is returned from the API" do
        subject { helper_class.new(api, resource_url: 'resource_url') }

        before do
          api.stub(:request).and_return(
            {
              'relations' => [{
                'resource_url' => 'relation_url'
              }]
            }
          )
        end

        it "makes a related collection object available" do
          expect(subject.relations).to be_a(RelationCollectionHelper)
        end

        it "passes keys from the api response to the new object" do
          RelationCollectionHelper.should_receive(:new).with(api, attribute_hashes: [{'resource_url' => 'relation_url'}])

          subject.relations
        end

        it "returns the same object each time" do
          expect(subject.relations).to be(subject.relations)
        end
      end

      context "and a collection isn't returned from the API" do
        subject { helper_class.new(api, resource_url: 'resource_url') }

        before do
          api.stub(:request).and_return({ 'foo' => 'bar' })
        end

        it "tries the API only once" do
          api.should_receive(:request).exactly(:once).and_return({ 'foo' => 'bar' })

          subject.relations
          subject.relations
        end

        it "still builds something"
      end
    end

    context "when a collection is passed in at creation" do
      let(:relation_collection) { RelationCollectionHelper.new }

      subject { helper_class.new(api, resource_url: 'resource_url', relations: relation_collection)}

      it "makes the passed-in related collection available" do
        expect(subject.relations).to be(relation_collection)
      end

      it "doesn't make any API calls" do
        api.should_not_receive(:request)

        subject.relations
      end
    end
  end

  describe "#fetch_attributes" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::Resource
      end
    end

    subject do
      helper_class.new(api, resource_url: 'resource_url')
    end

    it "makes a request to the API" do
      subject.api.should_receive(:request).with(:get, 'resource_url').and_return({})

      subject.send(:fetch_attributes)
    end

    it "defines getter methods for new attributes returned" do
      subject.api.stub(:request).and_return(foo: 'bar')

      subject.send(:fetch_attributes)

      expect(subject.foo).to eq('bar')
    end

    it "doesn't override existing getter methods" do
      def subject.foo
        'hard coded value'
      end

      subject.api.stub(:request).and_return(foo: 'bar')

      subject.send(:fetch_attributes)

      expect(subject.foo).to eq('hard coded value')
    end

    it "stores the response hash" do
      subject.api.stub(:request).and_return(foo: 'bar')

      subject.send(:fetch_attributes)

      expect(subject.api_attributes).to eq(foo: 'bar')
    end
  end

  describe "#api_attributes" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::Resource
      end
    end

    let(:api) do
      double('api', request: { foo: 'bar', boolean: false })
    end

    subject do
      helper_class.new(api, resource_url: 'resource_url')
    end

    it "hits the API only on first call" do
      api.should_receive(:request).exactly(:once)

      subject.api_attributes
      subject.api_attributes
    end

    it "caches the api response hash" do
      expect(subject.api_attributes).to eq(foo: 'bar', boolean: false)
    end
  end

  describe "#resource_url" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::Resource

        self.primary_key = :id
      end
    end

    context "when one is set at creation" do
      subject do
        helper_class.new(api, resource_url: 'resource_url')
      end

      it "returns the one passed in" do
        expect(subject.resource_url).to eq('resource_url')
      end
    end

    context "when one is not set at creation" do
      subject do
        helper_class.new(api, id: '33f1')
      end

      it "delegates URL construction to the api" do
        api.should_receive(:url_for).with(subject).and_return('helpers/33f1')

        expect(subject.resource_url).to eq('helpers/33f1')
      end
    end
  end

  describe "#delete" do
    let(:helper_class) do
      Class.new do
        include ContextIO::API::Resource
      end
    end

    subject do
      helper_class.new(double('api', :request => {'success' => true}), resource_url: 'resource_url')
    end

    it "makes a request to the API" do
      subject.api.should_receive(:request).with(:delete, 'resource_url')

      subject.delete
    end

    it "returns the contents of the 'success' key" do
      expect(subject.delete).to eq(true)
    end
  end
end
