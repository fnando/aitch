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

      Aitch::Request
        .should_receive(:new)
        .with(expected)
        .and_return(request)

      Aitch.get("URL", "DATA", "HEADERS", options)
    end

    it "performs request" do
      Aitch::Request.stub new: request
      request.should_receive(:perform)

      Aitch.get("URL")
    end
  end

  describe "#execute!" do
    it "returns response when successful" do
      response = double(error?: false)
      Aitch::Request.any_instance.stub perform: response

      expect(Aitch.get!("URL")).to eql(response)
    end

    it "raises when has errors" do
      response = double(error?: true, error: "ERROR")
      Aitch::Request.any_instance.stub perform: response

      expect {
        Aitch.get!("URL")
      }.to raise_error("ERROR")
    end
  end
end
