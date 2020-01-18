# frozen_string_literal: true

require "test_helper"

class HtmlParserTest < Minitest::Test
  test "instantiates Nokogiri" do
    Nokogiri.expects(:HTML).with("HTML")
    Aitch::ResponseParser::HTMLParser.load("HTML")
  end
end
