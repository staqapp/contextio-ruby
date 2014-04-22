require 'contextio/message'

describe ContextIO::Message do
  let(:api) { double('api') }

  subject { ContextIO::Message.new(api, resource_url: 'resource/url') }

  describe "#flags" do
    before do
      allow(api).to receive(:request).and_return({'seen' => 0})
    end

    it "gets to the flags method api" do
      expect(api).to receive(:request).with(
        :get,
        'resource/url/flags'
      )

      subject.flags
    end
  end

  describe "#set_flags" do
    before do
      allow(api).to receive(:request).and_return({'seen' => 1})
    end

    it "gets to the flags method api" do
      expect(api).to receive(:request).with(
        :post,
        'resource/url/flags',
        {:seen => 1}
      )

      subject.set_flags({:seen => true})
    end
  end
end
