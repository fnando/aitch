# frozen_string_literal: true

require "test_helper"

class JsonResponseTest < Minitest::Test
  test "detects as json" do
    register_uri(:get, "http://example.org/", body: "[]", content_type: "application/json")
    response = Aitch.get("http://example.org/")

    assert_predicate response, :json?
  end

  test "returns json" do
    register_uri(:get, "http://example.org/", body: "[1,2,3]", content_type: "application/json")
    response = Aitch.get("http://example.org/")

    assert_equal [1, 2, 3], response.data
  end
end
