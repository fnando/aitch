require "test_helper"

class JsonParserTest < Minitest::Test
  test "loads JSON" do
    JSON.expects(:load).with(%[{"a":1}])
    Aitch::ResponseParser::JSONParser.load(%[{"a":1}])
  end
end
