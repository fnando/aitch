# frozen_string_literal: true

require "test_helper"

class HtmlResponseTest < Minitest::Test
  test "detects as html" do
    register_uri(:get, "http://example.org/", body: "", content_type: "text/html")
    response = Aitch.get("http://example.org/")

    assert_predicate response, :html?
  end

  test "returns html" do
    register_uri(:get, "http://example.org/", body: "Hello", content_type: "text/html")
    response = Aitch.get("http://example.org/")

    assert_instance_of Nokogiri::HTML::Document, response.data
  end
end
