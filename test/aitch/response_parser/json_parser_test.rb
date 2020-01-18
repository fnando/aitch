# frozen_string_literal: true

require "test_helper"

class JsonParserTest < Minitest::Test
  test "loads JSON" do
    JSON.expects(:parse).with(%[{"a":1}])
    Aitch::ResponseParser::JSONParser.load(%[{"a":1}])
  end
end
