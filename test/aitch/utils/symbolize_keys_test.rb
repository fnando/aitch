# frozen_string_literal: true

require "test_helper"

class SymbolizeKeysTest < Minitest::Test
  test "converts keys to symbols" do
    expected = {a: 1}

    assert_equal expected, Aitch::Utils.symbolize_keys("a" => 1)
  end
end
