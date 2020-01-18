# frozen_string_literal: true

require "test_helper"

class Status3xxTest < Minitest::Test
  setup { Aitch.configuration.follow_redirect = false }

  test "sets default redirected from" do
    assert_equal [], Aitch::Response.new({}, stub("response")).redirected_from
  end

  test "uses provided redirected from" do
    assert_equal ["URL"], Aitch::Response.new({redirected_from: ["URL"]}, stub("response")).redirected_from
  end

  test "has body" do
    register_uri(:get, "http://example.org/", body: "Hello", status: 301)
    response = Aitch.get("http://example.org/")
    assert_equal "Hello", response.body
  end

  test "detects as successful response" do
    register_uri(:get, "http://example.org/", status: 301)
    response = Aitch.get("http://example.org/")

    assert response.success?
    assert response.ok?
  end

  test "detects as redirect" do
    register_uri(:get, "http://example.org/", status: 301)
    response = Aitch.get("http://example.org/")

    assert response.redirect?
  end

  test "returns location" do
    register_uri(:get, "http://example.org/", status: 301, location: "https://example.com/")
    response = Aitch.get("http://example.org/")
    assert_equal "https://example.com/", response.location
  end

  test "follows absolute paths" do
    Aitch.configuration.follow_redirect = true
    Aitch.configuration.redirect_limit = 5

    register_uri(:get, "http://example.org/", status: 301, location: "/hello")
    register_uri(:get, "http://example.org/hello", status: 301, location: "/hi")
    register_uri(:get, "http://example.org/hi", status: 200, body: "Hi")

    response = Aitch.get("http://example.org/")

    assert_equal ["http://example.org/", "http://example.org/hello"], response.redirected_from
    assert_equal "http://example.org/hi", response.url
    assert_equal "Hi", response.body
  end
end
