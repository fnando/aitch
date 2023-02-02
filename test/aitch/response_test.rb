# frozen_string_literal: true

require "test_helper"

class ResponseTest < Minitest::Test
  test "has body" do
    register_uri(:get, "http://example.org/", body: "Hello")
    response = Aitch.get("http://example.org/")

    assert_equal "Hello", response.body
  end

  test "sets current url" do
    register_uri(:get, "http://example.org/", body: "Hello")
    response = Aitch.get("http://example.org/")

    assert_equal "http://example.org/", response.url
  end

  test "parses gzip response" do
    stdio = StringIO.new
    gzipped = Zlib::GzipWriter.new(stdio)
    gzipped.write("Hello")
    gzipped.finish

    register_uri(:get, "http://example.org/", body: stdio.string, content_encoding: "gzip")
    response = Aitch.get("http://example.org/")

    assert_equal "Hello", response.body
  end

  test "deflates response" do
    deflated = Zlib::Deflate.deflate("Hello")

    register_uri(:get, "http://example.org/", body: deflated, content_encoding: "deflate")
    response = Aitch.get("http://example.org/")

    assert_equal "Hello", response.body
  end

  test "returns status code" do
    register_uri(:get, "http://example.org/", body: "")
    response = Aitch.get("http://example.org/")

    assert_equal 200, response.code
  end

  test "returns content type" do
    register_uri(:get, "http://example.org/", content_type: "text/html")
    response = Aitch.get("http://example.org/")

    assert_equal "text/html", response.content_type
  end

  test "detects as successful response" do
    register_uri(:get, "http://example.org/", content_type: "text/html")
    response = Aitch.get("http://example.org/")

    assert_predicate response, :success?
  end

  test "returns headers" do
    register_uri(:get, "http://example.org/", content_type: "text/html")
    headers = Aitch.get("http://example.org/").headers

    assert_instance_of Hash, headers
    assert_equal "text/html", headers["content-type"]
  end

  test "normalizes custom headers" do
    register_uri(:get, "http://example.org/", headers: {"X-Runtime" => "0.003"})
    headers = Aitch.get("http://example.org/").headers

    assert_equal "0.003", headers["runtime"]
  end

  test "maps missing methods to headers" do
    register_uri(:get, "http://example.org/", headers: {"X-Runtime" => "0.003"})
    response = Aitch.get("http://example.org/")

    assert_equal "0.003", response.runtime
    assert_respond_to response, :runtime
  end

  test "raises when have no method" do
    register_uri(:get, "http://example.org/")
    response = Aitch.get("http://example.org/")

    assert_raises(NoMethodError) { response.runtime }
  end

  test "returns description for 200 OK" do
    register_uri(:get, "http://example.org/", status: 200)
    response = Aitch.get("http://example.org/")

    assert_equal "200 OK", response.description
  end

  test "returns description for 101 Switch Protocol" do
    register_uri(:get, "http://example.org/", status: 101)
    response = Aitch.get("http://example.org/")

    assert_equal "101 Switch Protocol", response.description
  end

  test "returns description for 444 No Response (nginx)" do
    register_uri(:get, "http://example.org/", status: 444)
    response = Aitch.get("http://example.org/")

    assert_equal "444", response.description
  end

  test "overrides inspect" do
    register_uri(:get, "http://example.org/", status: 101, content_type: "text/html")
    response = Aitch.get("http://example.org/")

    assert_equal "#<Aitch::Response 101 Switch Protocol (text/html)>", response.inspect
  end
end
