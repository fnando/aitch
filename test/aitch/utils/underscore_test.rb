# frozen_string_literal: true

require "test_helper"

class UnderscoreTest < Minitest::Test
  test "replaces capital letters by underscores" do
    assert_equal "some_constant_name", Aitch::Utils.underscore("SomeConstantName")
  end

  test "considers URI acronym" do
    assert_equal "request_uri_too_long", Aitch::Utils.underscore("RequestURITooLong")
  end
end
