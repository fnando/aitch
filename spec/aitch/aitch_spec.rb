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
  end

  describe "#execute" do
    let(:request) { mock.as_null_object }

    it "delegates to Request" do
      Aitch::Request
        .should_receive(:new)
        .with("METHOD", "URL", "ARGS", "HEADERS", "OPTIONS")
        .and_return(request)

      Aitch.execute("METHOD", "URL", "ARGS", "HEADERS", "OPTIONS")
    end

    it "performs request" do
      Aitch::Request.stub new: request
      request.should_receive(:perform)

      Aitch.execute("METHOD", "URL")
    end
  end

  describe "#execute!" do
    it "returns response when successful" do
      response = stub(error?: false)
      Aitch::Request.any_instance.stub perform: response

      expect(Aitch.execute!("METHOD", "URL")).to eql(response)
    end

    it "raises when has errors" do
      response = stub(error?: true, error: "ERROR")
      Aitch::Request.any_instance.stub perform: response

      expect {
        Aitch.execute!("METHOD", "URL")
      }.to raise_error("ERROR")
    end
  end
end
