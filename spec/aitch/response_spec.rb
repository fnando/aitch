require "spec_helper"

describe Aitch::Response do
  it "has body" do
    FakeWeb.register_uri(:get, "http://example.org/", body: "Hello")
    response = Aitch.get("http://example.org/")
    expect(response.body).to eql("Hello")
  end

  it "sets current url" do
    FakeWeb.register_uri(:get, "http://example.org/", body: "Hello")
    response = Aitch.get("http://example.org/")
    expect(response.url).to eql("http://example.org/")
  end

  it "parses gzip response" do
    stdio = StringIO.new
    gzipped = Zlib::GzipWriter.new(stdio)
    gzipped.write("Hello")
    gzipped.finish

    FakeWeb.register_uri(:get, "http://example.org/", body: stdio.string, content_encoding: "gzip")
    response = Aitch.get("http://example.org/")

    expect(response.body).to eql("Hello")
  end

  it "deflates response" do
    stdio = StringIO.new
    deflated = Zlib::Deflate.deflate("Hello")

    FakeWeb.register_uri(:get, "http://example.org/", body: deflated, content_encoding: "deflate")
    response = Aitch.get("http://example.org/")

    expect(response.body).to eql("Hello")
  end

  it "returns status code" do
    FakeWeb.register_uri(:get, "http://example.org/", body: "")
    response = Aitch.get("http://example.org/")
    expect(response.code).to eql(200)
  end

  it "returns content type" do
    FakeWeb.register_uri(:get, "http://example.org/", content_type: "text/html")
    response = Aitch.get("http://example.org/")
    expect(response.content_type).to eql("text/html")
  end

  it "detects as successful response" do
    FakeWeb.register_uri(:get, "http://example.org/", content_type: "text/html")
    response = Aitch.get("http://example.org/")
    expect(response).to be_success
  end

  it "returns headers" do
    FakeWeb.register_uri(:get, "http://example.org/", content_type: "text/html")
    headers = Aitch.get("http://example.org/").headers

    expect(headers).to be_a(Hash)
    expect(headers["content-type"]).to eql("text/html")
  end

  it "normalizes custom headers" do
    FakeWeb.register_uri(:get, "http://example.org/", "X-Runtime" => "0.003")
    headers = Aitch.get("http://example.org/").headers

    expect(headers["runtime"]).to eql("0.003")
  end

  it "maps missing methods to headers" do
    FakeWeb.register_uri(:get, "http://example.org/", "X-Runtime" => "0.003")
    response = Aitch.get("http://example.org/")

    expect(response.runtime).to eql("0.003")
    expect(response).to respond_to(:runtime)
  end

  context "status 3xx" do
    before { Aitch.configuration.follow_redirect = false }

    it "has body" do
      FakeWeb.register_uri(:get, "http://example.org/", body: "Hello", status: 301)
      response = Aitch.get("http://example.org/")
      expect(response.body).to eql("Hello")
    end

    it "detects as successful response" do
      FakeWeb.register_uri(:get, "http://example.org/", status: 301)
      response = Aitch.get("http://example.org/")

      expect(response).to be_success
      expect(response).to be_ok
    end

    it "detects as redirect" do
      FakeWeb.register_uri(:get, "http://example.org/", status: 301)
      response = Aitch.get("http://example.org/")
      expect(response).to be_redirect
    end

    it "returns location" do
      FakeWeb.register_uri(:get, "http://example.org/", status: 301, location: "https://example.com/")
      response = Aitch.get("http://example.org/")
      expect(response.location).to eql("https://example.com/")
    end

    it "follows absolute paths" do
      Aitch.configuration.follow_redirect = true
      Aitch.configuration.redirect_limit = 5

      FakeWeb.register_uri(:get, "http://example.org/", status: 301, location: "/hello")
      FakeWeb.register_uri(:get, "http://example.org/hello", status: 301, location: "/hi")
      FakeWeb.register_uri(:get, "http://example.org/hi", status: 200, body: "Hi")

      response = Aitch.get("http://example.org/")

      expect(response.redirected_from).to eql(["http://example.org/", "http://example.org/hello"])
      expect(response.url).to eql("http://example.org/hi")
      expect(response.body).to eql("Hi")
    end
  end

  context "status 4xx" do
    it "detects as error" do
      FakeWeb.register_uri(:get, "http://example.org/", status: 404)
      response = Aitch.get("http://example.org/")

      expect(response).to be_error
    end

    it "sets error" do
      FakeWeb.register_uri(:get, "http://example.org/", status: 404)
      response = Aitch.get("http://example.org/")

      expect(response.error).to eql(Aitch::NotFoundError)
    end
  end

  context "status 5xx" do
    it "detects as error" do
      FakeWeb.register_uri(:get, "http://example.org/", status: 500)
      response = Aitch.get("http://example.org/")

      expect(response).to be_error
    end

    it "sets error" do
      FakeWeb.register_uri(:get, "http://example.org/", status: 500)
      response = Aitch.get("http://example.org/")

      expect(response.error).to eql(Aitch::InternalServerErrorError)
    end
  end

  context "JSON" do
    it "detects as json" do
      FakeWeb.register_uri(:get, "http://example.org/", body: "[]", content_type: "application/json")
      response = Aitch.get("http://example.org/")

      expect(response).to be_json
    end

    it "returns json" do
      FakeWeb.register_uri(:get, "http://example.org/", body: "[1,2,3]", content_type: "application/json")
      response = Aitch.get("http://example.org/")

      expect(response.json).to eql([1,2,3])
    end
  end

  context "HTML" do
    it "detects as html" do
      FakeWeb.register_uri(:get, "http://example.org/", body: "", content_type: "text/html")
      response = Aitch.get("http://example.org/")

      expect(response).to be_html
    end

    it "returns html" do
      FakeWeb.register_uri(:get, "http://example.org/", body: "Hello", content_type: "text/html")
      response = Aitch.get("http://example.org/")

      expect(response.html).to be_a(Nokogiri::HTML::Document)
    end
  end

  context "XML" do
    it "detects as xml" do
      FakeWeb.register_uri(:get, "http://example.org/", body: "[]", content_type: "application/xml")
      response = Aitch.get("http://example.org/")

      expect(response).to be_xml
    end

    it "returns xml" do
      FakeWeb.register_uri(:get, "http://example.org/", body: "<foo/>", content_type: "application/xml")
      response = Aitch.get("http://example.org/")

      expect(response.xml).to be_a(Nokogiri::XML::Document)
    end
  end

  Aitch::Response::ERRORS.each do |code, exception|
    name = Aitch::Utils.underscore(exception.name.split("::").last).gsub("_error", "")

    it "detects response as #{name}" do
      config = double
      http_response = double(code: code)
      response = Aitch::Response.new(config, http_response)
      expect(response.public_send("#{name}?")).to be_truthy
    end
  end
end
