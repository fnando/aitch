# frozen_string_literal: true

require "test_helper"

class StatusCodeValidationTest < Minitest::Test
  test "raises exception when status code isn't valid" do
    register_uri(:get, "http://example.org/", status: 404)

    error = assert_raises(Aitch::StatusCodeError) do
      Aitch.get("http://example.org/", {}, {}, expect: [200])
    end

    assert_equal "Expected(200 OK) <=> Actual(404 Not Found)", error.message
  end

  test "accepts valid status code" do
    register_uri(:get, "http://example.org/", status: 200)
    Aitch.get("http://example.org/", {}, {}, expect: [200])
  end
end
