require "spec_helper"

describe Aitch::Request do
  def build_request(options = {})
    Aitch::Request.new({
      request_method: "get",
      url: "http://example.org",
      options: {}
    }.merge(options))
  end

  it "sets content type" do
    request = build_request(content_type: 'application/json')
    expect(request.content_type).to eq('application/json')
  end

  it "raises with invalid uri" do
    expect {
      build_request(url: "\\").uri
    }.to raise_error(Aitch::InvalidURIError)
  end

  it "raises on timeout", ruby: 2.0 do
    request = build_request(request_method: "post", url: "http://example.org")
    allow(request).to receive_message_chain(:client, :request).and_raise(Net::ReadTimeout)

    expect {
      request.perform
    }.to raise_error(Aitch::RequestTimeoutError)
  end

  it "raises on timeout", ruby: 1.9 do
    request = build_request(request_method: "post", url: "http://example.org")
    allow(request).to receive_message_chain(:client, :request).and_raise(Timeout::Error)

    expect {
      request.perform
    }.to raise_error(Aitch::RequestTimeoutError)
  end

  it "sets user agent" do
    requester = build_request
    request = requester.request
    expect(request["User-Agent"]).to eql(requester.options[:user_agent])
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
    request = build_request(request_method: "post", data: {a: 1}).request
    expect(request.body).to eql("a=1")
  end

  it "sets request body from string" do
    request = build_request(request_method: "post", data: "some body").request
    expect(request.body).to eql("some body")
  end

  it "sets json body from object" do
    request = build_request(
      request_method: "post",
      data: {a: 1},
      content_type: "application/json",
      options: {json_parser: JSON}
    ).request

    expect(request.body).to eql({a: 1}.to_json)
  end

  it "sets json body from object (default headers)" do
    request = build_request(
      request_method: "post",
      data: {a: 1},
      options: {json_parser: JSON, default_headers: {'Content-Type' => 'application/json'}}
    ).request

    expect(request.body).to eql({a: 1}.to_json)
  end

  it "sets request body from to_h protocol" do
    data = double(to_h: {a: 1})
    request = build_request(request_method: "post", data: data).request
    expect(request.body).to eql("a=1")
  end

  it "sets request body from to_s protocol" do
    data = double(to_s: "some body")
    request = build_request(request_method: "post", data: data).request

    expect(request.body).to eql("some body")
  end

  it "sets query string from hash data" do
    FakeWeb.register_uri :get, "http://example.org/?a=1&b=2", body: "hello"
    requester = build_request(data: {a: 1, b: 2})

    expect(requester.perform.body).to eql("hello")
  end

  it "sets default headers" do
    requester = build_request
    requester.options[:default_headers] = {"HEADER" => "VALUE"}
    request = requester.request

    expect(request["HEADER"]).to eql("VALUE")
  end

  it "sets custom headers" do
    request = build_request(headers: {"HEADER" => "VALUE"}).request
    expect(request["HEADER"]).to eql("VALUE")
  end

  it "executes headers with callable protocol" do
    request = build_request(headers: {"HEADER" => -> { "VALUE" }}).request
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
        expect(client.use_ssl?).to be_truthy
      end

      it "sets verification mode" do
        expect(client.verify_mode).to eql(OpenSSL::SSL::VERIFY_PEER)
      end

      it "sets timeout" do
        request.options[:timeout] = 20
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
      FakeWeb.register_uri(:get, "http://example.com/", location: "http://www.example.com/", status: 301)
      FakeWeb.register_uri(:get, "http://www.example.com/", body: "Hello")

      response = Aitch.get("http://example.org/")

      expect(response).not_to be_redirect
      expect(response.body).to eql("Hello")
      expect(response.redirected_from).to eql(["http://example.org/", "http://example.com/"])
      expect(response.url).to eql("http://www.example.com/")
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

  describe "GET requests" do
    it "sets data as query string" do
      FakeWeb.register_uri(:get, %r[.+], body: "")
      Aitch.get("http://example.org/", a: 1, b: 2)

      expect(FakeWeb.last_request.path).to eql("/?a=1&b=2")
    end
  end

  describe "using the DSL" do
    it "performs request" do
      FakeWeb.register_uri(:post, %r[.+], body: "")

      response = Aitch.post do
        url "http://example.org/some/path"
        params a: 1, b: 2
        headers Rendering: "0.1"
        options user: "user", password: "pass"
      end

      expect(FakeWeb.last_request.path).to eql("/some/path")
      expect(FakeWeb.last_request.method).to eql("POST")
      expect(FakeWeb.last_request.body).to eql("a=1&b=2")
      expect(FakeWeb.last_request["Rendering"]).to eql("0.1")

      auth = Base64.encode64("user:pass").chomp
      expect(FakeWeb.last_request["Authorization"]).to eql("Basic #{auth}")
    end
  end
end
