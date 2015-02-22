require "spec_helper"

describe Aitch do
  context "request methods" do
    it { should respond_to(:get) }
    it { should respond_to(:get!) }
    it { should respond_to(:post) }
    it { should respond_to(:post!) }
    it { should respond_to(:put) }
    it { should respond_to(:put!) }
    it { should respond_to(:patch) }
    it { should respond_to(:patch!) }
    it { should respond_to(:delete) }
    it { should respond_to(:delete!) }
    it { should respond_to(:head) }
    it { should respond_to(:head!) }
    it { should respond_to(:options) }
    it { should respond_to(:options!) }
    it { should respond_to(:trace) }
    it { should respond_to(:trace!) }
    it { should respond_to(:execute) }
    it { should respond_to(:execute!) }
    it { should respond_to(:config) }
    it { should respond_to(:configuration) }
  end

  describe "#execute" do
    let(:request) { double.as_null_object }

    it "delegates to Request" do
      options = {}

      expected = {
        request_method: "get",
        url: "URL",
        data: "DATA",
        headers: "HEADERS",
        options: options.merge(Aitch.config.to_h)
      }

      expect(Aitch::Request).to receive(:new).with(expected).and_return(request)

      Aitch.get("URL", "DATA", "HEADERS", options)
    end

    it "performs request" do
      allow(Aitch::Request).to receive(:new).and_return(request)
      expect(request).to receive(:perform)

      Aitch.get("URL")
    end
  end

  describe "#execute!" do
    it "returns response when successful" do
      response = double(error?: false)
      allow_any_instance_of(Aitch::Request).to receive(:perform).and_return(response)

      expect(Aitch.get!("URL")).to eq(response)
    end

    it "raises when has errors" do
      response = double(error?: true, error: "ERROR")
      allow_any_instance_of(Aitch::Request).to receive(:perform).and_return(response)

      expect {
        Aitch.get!("URL")
      }.to raise_error("ERROR")
    end
  end
end
