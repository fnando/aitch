# frozen_string_literal: true

require "test_helper"

class XmlParserTest < Minitest::Test
  test "instantiates Nokogiri" do
    Nokogiri.expects(:XML).with("XML", nil, "utf-8")
    Aitch::ResponseParser::XMLParser.load("XML")
  end

  test "converts ISO-8859-1 to UTF-8" do
    xml = Aitch::ResponseParser::XMLParser.load(File.read("./test/fixtures/iso8859-1.xml"))

    assert_equal "utf-8", xml.encoding
    assert_includes xml.to_xml, %[<?xml version="1.0" encoding="utf-8"?>]
  end
end
