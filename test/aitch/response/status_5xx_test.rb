# frozen_string_literal: true

require "test_helper"

class Status5xxTest < Minitest::Test
  test "detects as error" do
    register_uri(:get, "http://example.org/", status: 500)
    response = Aitch.get("http://example.org/")

    assert_predicate response, :error?
  end

  test "sets error" do
    register_uri(:get, "http://example.org/", status: 500)
    response = Aitch.get("http://example.org/")

    assert_equal Aitch::InternalServerErrorError, response.error
  end
end
