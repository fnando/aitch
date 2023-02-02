# frozen_string_literal: true

require "test_helper"

class UriTest < Minitest::Test
  test "returns default path" do
    assert_equal "/", Aitch::URI.new("http://example.org").path
  end

  test "returns defined path" do
    assert_equal "/some/path", Aitch::URI.new("http://example.org/some/path").path
  end

  test "returns fragment" do
    assert_equal "#top", Aitch::URI.new("http://example.org/#top").fragment
  end

  test "returns query string" do
    assert_equal "?a=1&b=2", Aitch::URI.new("http://example.org/?a=1&b=2").query
  end

  test "converts data into query string" do
    assert_equal "?a=1&b=2", Aitch::URI.new("http://example.org", a: 1, b: 2).query
  end

  test "merges data into query string" do
    assert_equal "?a=1&b=2&c=3", Aitch::URI.new("http://example.org/?a=1&b=2", c: 3).query
  end

  test "ignores data when request has body" do
    assert_nil Aitch::URI.new("http://example.org/", {c: 3}, true).query
  end

  test "returns request uri" do
    uri = Aitch::URI.new("http://example.org/some/path?a=1&b=2#hello", c: 3)

    assert_equal "/some/path?a=1&b=2&c=3#hello", uri.request_uri
  end
end
