require "spec_helper"

describe Aitch::Request do
  it "raises with invalid uri" do
    expect {
      Aitch::Request.new("post", "\\").uri
    }.to raise_error(Aitch::InvalidURIError)
  end

  it "raises on timeout", ruby: 2.0 do
    request = Aitch::Request.new("post", "http://example.org")
    request.stub_chain(:client, :request).and_raise(Net::ReadTimeout)

    expect {
      request.perform
    }.to raise_error(Aitch::RequestTimeoutError)
  end

  it "raises on timeout", ruby: 1.9 do
    request = Aitch::Request.new("post", "http://example.org")
    request.stub_chain(:client, :request).and_raise(Timeout::Error)

    expect {
      request.perform
    }.to raise_error(Aitch::RequestTimeoutError)
  end

  it "sets user agent" do
    request = Aitch::Request.new("post", "http://example.org/some/path").request
    expect(request["User-Agent"]).to eql(Aitch.configuration.user_agent)
  end

  it "requests gzip encoding" do
    request = Aitch::Request.new("get", "http://example.org").request
    expect(request["Accept-Encoding"]).to eql("gzip,deflate")
  end

  it "sets path" do
    request = Aitch::Request.new("post", "http://example.org/some/path").request
    expect(request.path).to eql("/some/path")
  end

  it "sets request body from hash" do
    request = Aitch::Request.new("post", "http://example.org/", {a: 1}).request
    expect(request.body).to eql("a=1")
  end

  it "sets request body from string" do
    request = Aitch::Request.new("post", "http://example.org/", "some body").request
    expect(request.body).to eql("some body")
  end

  it "sets request body from to_h protocol" do
    data = stub(to_h: {a: 1})
    request = Aitch::Request.new("post", "http://example.org/", data).request
    expect(request.body).to eql("a=1")
  end

  it "sets request body from to_s protocol" do
    data = stub(to_s: "some body")
    request = Aitch::Request.new("post", "http://example.org/", data).request

    expect(request.body).to eql("some body")
  end

  it "sets default headers" do
    Aitch.configuration.default_headers = {"HEADER" => "VALUE"}
    request = Aitch::Request.new("post", "http://example.org/").request
    expect(request["HEADER"]).to eql("VALUE")
  end

  it "sets custom headers" do
    request = Aitch::Request.new("post", "http://example.org/", {}, {"HEADER" => "VALUE"}).request
    expect(request["HEADER"]).to eql("VALUE")
  end

  it "sets basic auth credentials" do
    request = Aitch::Request.new("post", "http://example.org/", {}, {}, {user: "USER", password: "PASS"}).request
    credentials = Base64.decode64(request["Authorization"].gsub(/Basic /, ""))

    expect(credentials).to eql("USER:PASS")
  end

  describe "#client" do
    context "https" do
      subject(:client) {
        Aitch::Request.new("get", "https://example.org").client
      }

      it "sets https" do
        expect(client.use_ssl?).to be_true
      end

      it "sets verification mode" do
        expect(client.verify_mode).to eql(OpenSSL::SSL::VERIFY_PEER)
      end

      it "sets timeout" do
        Aitch.configuration.timeout = 20
        expect(client.read_timeout).to eql(20)
      end
    end
  end

  describe "Request class" do
    it "raises with invalid method" do
      expect {
        Aitch::Request.new("invalid", "URL").request
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
        request = Aitch::Request.new(method, "URL").request
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
