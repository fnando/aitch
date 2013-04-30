require "spec_helper"

describe Aitch::Request do
  def build_request(options = {})
    Aitch::Request.new({
      request_method: "get",
      url: "URL",
      config: Aitch::Configuration.new
    }.merge(options))
  end

  it "raises with invalid uri" do
    expect {
      build_request(url: "\\").uri
    }.to raise_error(Aitch::InvalidURIError)
  end

  it "raises on timeout", ruby: 2.0 do
    request = build_request(request_method: "post", url: "http://example.org")
    request.stub_chain(:client, :request).and_raise(Net::ReadTimeout)

    expect {
      request.perform
    }.to raise_error(Aitch::RequestTimeoutError)
  end

  it "raises on timeout", ruby: 1.9 do
    request = build_request(request_method: "post", url: "http://example.org")
    request.stub_chain(:client, :request).and_raise(Timeout::Error)

    expect {
      request.perform
    }.to raise_error(Aitch::RequestTimeoutError)
  end

  it "sets user agent" do
    requester = build_request
    request = requester.request
    expect(request["User-Agent"]).to eql(requester.config.user_agent)
  end

  it "requests gzip encoding" do
    request = build_request.request
    expect(request["Accept-Encoding"]).to eql("gzip,deflate")
  end

  it "sets path" do
    request = build_request(url: "http://example.org/some/path").request
    expect(request.path).to eql("/some/path")
  end

  it "sets request body from hash" do
    request = build_request(data: {a: 1}).request
    expect(request.body).to eql("a=1")
  end

  it "sets request body from string" do
    request = build_request(data: "some body").request
    expect(request.body).to eql("some body")
  end

  it "sets request body from to_h protocol" do
    data = stub(to_h: {a: 1})
    request = build_request(data: data).request
    expect(request.body).to eql("a=1")
  end

  it "sets request body from to_s protocol" do
    data = stub(to_s: "some body")
    request = build_request(data: data).request

    expect(request.body).to eql("some body")
  end

  it "sets default headers" do
    requester = build_request
    requester.config.default_headers = {"HEADER" => "VALUE"}
    request = requester.request

    expect(request["HEADER"]).to eql("VALUE")
  end

  it "sets custom headers" do
    request = build_request(headers: {"HEADER" => "VALUE"}).request
    expect(request["HEADER"]).to eql("VALUE")
  end

  it "sets basic auth credentials" do
    request = build_request(options: {user: "USER", password: "PASS"}).request
    credentials = Base64.decode64(request["Authorization"].gsub(/Basic /, ""))

    expect(credentials).to eql("USER:PASS")
  end

  describe "#client" do
    context "https" do
      let(:request) { build_request(url: "https://example.org") }
      subject(:client) { request.client }

      it "sets https" do
        expect(client.use_ssl?).to be_true
      end

      it "sets verification mode" do
        expect(client.verify_mode).to eql(OpenSSL::SSL::VERIFY_PEER)
      end

      it "sets timeout" do
        request.config.timeout = 20
        expect(client.read_timeout).to eql(20)
      end
    end
  end

  describe "Request class" do
    it "raises with invalid method" do
      expect {
        build_request(request_method: "invalid").request
      }.to raise_error(Aitch::InvalidHTTPMethodError, %[unexpected HTTP verb: "invalid"])
    end

    %w[
      get
      post
      put
      patch
      delete
      head
      options
      trace
    ].each do |method|
      it "instantiates #{method.upcase} method" do
        request = build_request(request_method: method).request
        expect(request.class.name).to eql("Net::HTTP::#{method.capitalize}")
      end
    end
  end

  describe "follow redirection" do
    before { Aitch.configuration.follow_redirect = true }

    it "follows redirect" do
      Aitch.configuration.redirect_limit = 5

      FakeWeb.register_uri(:get, "http://example.org/", location: "http://example.com/", status: 301)
      FakeWeb.register_uri(:get, "http://example.com/", body: "Hello")

      response = Aitch.get("http://example.org")

      expect(response).not_to be_redirect
      expect(response.body).to eql("Hello")
    end

    it "raises when doing too many redirects" do
      Aitch.configuration.redirect_limit = 1

      FakeWeb.register_uri(:get, "http://example.org/", location: "http://example.com/", status: 301)
      FakeWeb.register_uri(:get, "http://example.com/", location: "https://example.com/", status: 301)

      expect {
        Aitch.get("http://example.org/")
      }.to raise_error(Aitch::TooManyRedirectsError)
    end
  end
end
