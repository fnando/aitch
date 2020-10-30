# frozen_string_literal: true

require "test_helper"
require "csv"

class DefaultResponseParserTest < Minitest::Test
  test "returns application/custom" do
    register_uri(:get, "http://example.org/file.custom", body: "1,2,3", content_type: "application/custom")
    response = Aitch.get("http://example.org/file.custom")

    assert_instance_of String, response.data
    assert_equal %[1,2,3], response.data
  end
end
