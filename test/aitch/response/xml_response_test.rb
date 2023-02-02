# frozen_string_literal: true

require "test_helper"

class XmlResponseTest < Minitest::Test
  test "detects as xml" do
    register_uri(:get, "http://example.org/", body: "[]", content_type: "application/xml")
    response = Aitch.get("http://example.org/")

    assert_predicate response, :xml?
  end

  test "returns xml" do
    register_uri(:get, "http://example.org/", body: "<foo/>", content_type: "application/xml")
    response = Aitch.get("http://example.org/")

    assert_instance_of Nokogiri::XML::Document, response.data
  end
end
