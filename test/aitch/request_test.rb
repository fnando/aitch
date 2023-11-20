# frozen_string_literal: true

require "test_helper"

class RequestTest < Minitest::Test
  test "sets content type" do
    request = build_request(content_type: "application/json")

    assert_equal "application/json", request.content_type
  end

  test "raises with invalid uri" do
    assert_raises(Aitch::InvalidURIError) { build_request(url: "\\").uri }
  end

  test "raises on timeout" do
    request = build_request(request_method: "post", url: "http://example.org")
    request.client.stubs(:request).raises(Net::ReadTimeout)

    assert_raises(Aitch::RequestTimeoutError) { request.perform }
  end

  test "raises exception for invalid http method" do
    request = build_request(request_method: "invalid", url: "http://example.org")

    assert_raises(Aitch::InvalidHTTPMethodError) { request.perform }
  end

  test "sets user agent" do
    requester = build_request(headers: {"User-Agent" => "CUSTOM"})
    request = requester.request

    assert_equal "CUSTOM", requester.headers["User-Agent"]
    assert_equal "CUSTOM", request["User-Agent"]
  end

  test "requests gzip encoding" do
    request = build_request.request

    assert_equal "gzip,deflate", request["Accept-Encoding"]
  end

  test "sets path" do
    request = build_request(url: "http://example.org/some/path").request

    assert_equal "/some/path", request.path
  end

  test "sets request body from hash" do
    request = build_request(request_method: "post", data: {a: 1}).request

    assert_equal "a=1", request.body
  end

  test "sets request body from string" do
    request = build_request(request_method: "post", data: "some body").request

    assert_equal "some body", request.body
  end

  test "sets request body from params key" do
    request = build_request(request_method: "post", params: "some body").request

    assert_equal "some body", request.body
  end

  test "sets json body from object" do
    request = build_request(
      request_method: "post",
      data: {a: 1},
      content_type: "application/json",
      options: {json_parser: JSON}
    ).request

    expected = {a: 1}.to_json

    assert_equal expected, request.body
  end

  test "sets json body from object (default headers)" do
    request = build_request(
      request_method: "post",
      data: {a: 1},
      options: {json_parser: JSON, default_headers: {"Content-Type" => "application/json"}}
    ).request

    expected = {a: 1}.to_json

    assert_equal expected, request.body
  end

  test "sets request body from to_h protocol" do
    data = stub(to_h: {a: 1})
    request = build_request(request_method: "post", data: data).request

    assert_equal "a=1", request.body
  end

  test "sets json body from array" do
    data = [1, 2, 3]
    request = build_request(
      request_method: "post",
      data: data,
      content_type: "application/json",
      options: {json_parser: JSON}
    ).request

    assert_equal "[1,2,3]", request.body
  end

  test "sets request body from to_s protocol" do
    data = stub(to_s: "some body")
    request = build_request(request_method: "post", data: data).request

    assert_equal "some body", request.body
  end

  test "sets query string from hash data" do
    register_uri :get, "http://example.org/?a=1&b=2", body: "hello"
    requester = build_request(data: {a: 1, b: 2})

    assert_equal "hello", requester.perform.body
  end

  test "sets default headers" do
    requester = build_request
    requester.options[:default_headers] = {"HEADER" => "VALUE"}
    request = requester.request

    assert_equal "VALUE", request["HEADER"]
  end

  test "sets custom headers" do
    request = build_request(headers: {"HEADER" => "VALUE"}).request

    assert_equal "VALUE", request["HEADER"]
  end

  test "sets headers from underscored headers" do
    request = build_request(headers: {content_type: "text/plain"}).request

    assert_equal "text/plain", request["Content-Type"]
  end

  test "executes headers with callable protocol" do
    request = build_request(headers: {"HEADER" => -> { "VALUE" }}).request

    assert_equal "VALUE", request["HEADER"]
  end

  test "sets basic auth credentials" do
    request = build_request(options: {user: "USER", password: "PASS"}).request
    credentials = Base64.decode64(request["Authorization"].gsub("Basic ", ""))

    assert_equal "USER:PASS", credentials
  end

  test "performs request when using dsl" do
    register_uri(:post, /.+/)

    Aitch.post do
      url "http://example.org/some/path"
      params a: 1, b: 2
      headers Rendering: "0.1"
      options user: "user", password: "pass"
    end

    assert_equal "/some/path", last_request.uri.request_uri
    assert_equal :post, last_request.method
    assert_equal "a=1&b=2", last_request.body
    assert_equal "0.1", last_request.headers["Rendering"]
    assert_equal "user:pass", Base64.decode64(last_request.headers["Authorization"].split.last)
  end

  test "performs request when using kwargs" do
    register_uri(:post, /.+/)

    Aitch.post(
      url: "http://example.org/some/path",
      data: {a: 1, b: 2},
      headers: {Rendering: "0.1"},
      options: {user: "user", password: "pass"}
    )

    assert_equal "/some/path", last_request.uri.request_uri
    assert_equal :post, last_request.method
    assert_equal "a=1&b=2", last_request.body
    assert_equal "0.1", last_request.headers["Rendering"]
    assert_equal "user:pass", Base64.decode64(last_request.headers["Authorization"].split.last)
  end

  test "uses base url" do
    register_uri(:get, /.+/)

    client = Aitch::Namespace.new
    client.configure {|c| c.base_url = "https://example.com" }

    client.get("/some/path")

    assert_equal "/some/path", last_request.uri.request_uri
    assert_equal "example.com", last_request.uri.host
    assert_equal "https", last_request.uri.scheme
  end
end
