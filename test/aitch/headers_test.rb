# frozen_string_literal: true

require "test_helper"

class HeadersTest < Minitest::Test
  let(:headers) { Aitch::Headers.new }

  test "normalizes header name" do
    headers[:content_type] = "application/json"

    assert_equal "application/json", headers["Content-Type"]
    assert_equal "application/json", headers[:content_type]
    assert_equal "application/json", headers["content-type"]
    assert_equal({"content-type" => "application/json"}, headers.to_h)
    assert headers == {"content-type" => "application/json"} #  rubocop:disable Minitest/AssertEqual, Minitest/AssertOperator
  end

  test "implements key?" do
    headers[:content_type] = "application/json"

    assert headers.key?("Content-Type")
    assert headers.key?("content-type")
    assert headers.key?(:content_type)
  end

  test "implements empty?" do
    assert_empty headers
  end

  test "implements any?" do
    refute headers.any?
  end

  test "implements delete" do
    headers[:content_type] = "application/json"
    headers.delete("Content-Type")

    assert_empty headers
  end
end
