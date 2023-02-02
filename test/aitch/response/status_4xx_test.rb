# frozen_string_literal: true

require "test_helper"

class Status4xxTest < Minitest::Test
  test "detects as error" do
    register_uri(:get, "http://example.org/", status: 404)
    response = Aitch.get("http://example.org/")

    assert_predicate response, :error?
  end

  test "sets error" do
    register_uri(:get, "http://example.org/", status: 404)
    response = Aitch.get("http://example.org/")

    assert_equal Aitch::NotFoundError, response.error
  end
end
