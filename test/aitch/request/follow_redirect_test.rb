# frozen_string_literal: true

require "test_helper"

class FollowRedirectTest < Minitest::Test
  setup { Aitch.configuration.follow_redirect = true }

  test "follows redirect" do
    Aitch.configuration.redirect_limit = 5

    register_uri(:get, "http://example.org/", location: "http://example.com/", status: 301)
    register_uri(:get, "http://example.com/", location: "http://www.example.com/", status: 301)
    register_uri(:get, "http://www.example.com/", body: "Hello")

    response = Aitch.get("http://example.org/")

    refute_predicate response, :redirect?
    assert_equal "Hello", response.body
    assert_equal ["http://example.org/", "http://example.com/"], response.redirected_from
    assert_equal "http://www.example.com/", response.url
  end

  test "raises when doing too many redirects" do
    Aitch.configuration.redirect_limit = 1

    register_uri(:get, "http://example.org/", location: "http://example.com/", status: 301)
    register_uri(:get, "http://example.com/", location: "https://example.com/", status: 301)

    assert_raises(Aitch::TooManyRedirectsError) do
      Aitch.get("http://example.org/")
    end
  end

  test "returns only redirection urls" do
    Aitch.configuration.redirect_limit = 5

    register_uri(:get, "http://example.org/", location: "http://example.com/", status: 301)
    register_uri(:get, "http://example.com/", status: 200)

    response = Aitch.get("http://example.org/")

    assert_equal "http://example.com/", response.url
    assert_equal ["http://example.org/"], response.redirected_from
  end

  test "honors 307 status" do
    Aitch.configuration.follow_redirect = true
    Aitch.configuration.redirect_limit = 5

    register_uri(:post, "http://example.org/", status: 307, location: "/hi")
    register_uri(:post, "http://example.org/hi", status: 307, location: "/hello")
    register_uri(:post, "http://example.org/hello", status: 200)

    response = Aitch.post("http://example.org/", {a: 1}, Range: "1..100")

    assert_equal "http://example.org/hello", response.url
    assert_equal 200, response.code
    assert_equal ["http://example.org/", "http://example.org/hi"], response.redirected_from

    request = WebMock.requests.last

    assert_equal "a=1", request.body
    assert_equal "1..100", request.headers["Range"]
  end
end
