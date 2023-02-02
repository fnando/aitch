# frozen_string_literal: true

require "test_helper"

class ExecuteTest < Minitest::Test
  let(:request) { stub_everything }

  test "delegates to Request" do
    options = {}

    expected = {
      request_method: "get",
      url: "URL",
      data: "DATA",
      headers: "HEADERS",
      options: options.merge(Aitch.config.to_h)
    }

    Aitch::Request.expects(:new).with(expected).returns(request)

    Aitch.get("URL", "DATA", "HEADERS", options)
  end

  test "performs request" do
    Aitch::Request.stubs(:new).returns(request)
    request.expects(:perform)

    Aitch.get("URL")
  end
end

class ExecuteBangTest < Minitest::Test
  test "returns response when successful" do
    response = stub(error?: false)
    Aitch::Request.any_instance.stubs(:perform).returns(response)

    assert_equal response, Aitch.get!("URL")
  end

  test "raises when has errors" do
    response = stub(error?: true, error: "ERROR")
    Aitch::Request.any_instance.stubs(:perform).returns(response)

    assert_raises(StandardError, "ERROR") { Aitch.get!("URL") }
  end
end
