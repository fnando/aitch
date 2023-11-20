# frozen_string_literal: true

require "test_helper"

class ErrorsTest < Minitest::Test
  Aitch::Response::ERRORS.each do |code, exception|
    name = Aitch::Utils.underscore(exception.name.split("::").last).gsub("_error", "")

    test "detects response as #{name}" do
      config = {}
      http_response = stub(code: code, content_type: "text/html")
      response = Aitch::Response.new(config, http_response)

      assert response.public_send("#{name}?")
    end
  end
end
