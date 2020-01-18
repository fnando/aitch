# frozen_string_literal: true

require "test_helper"

class RawResponseTest < Minitest::Test
  test "returns body as it is (raw)" do
    register_uri(:get, "http://example.org/", body: "HELLO", content_type: "text/plain")
    response = Aitch.get("http://example.org/")

    assert_equal "HELLO", response.body
  end
end
