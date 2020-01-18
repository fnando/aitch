# frozen_string_literal: true

require "test_helper"

class JsonRequestTest < Minitest::Test
  test "uses json parser" do
    register_uri(:post, "http://example.org/", status: 200)
    Aitch.post do
      url "http://example.org/"
      body a: 1
      headers "Content-Type" => "application/json"
    end
  end
end
