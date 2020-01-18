# frozen_string_literal: true

require "test_helper"

class AitchTest < Minitest::Test
  test "defines public API" do
    assert Aitch.respond_to?(:get)
    assert Aitch.respond_to?(:get!)
    assert Aitch.respond_to?(:post)
    assert Aitch.respond_to?(:post!)
    assert Aitch.respond_to?(:put)
    assert Aitch.respond_to?(:put!)
    assert Aitch.respond_to?(:patch)
    assert Aitch.respond_to?(:patch!)
    assert Aitch.respond_to?(:delete)
    assert Aitch.respond_to?(:delete!)
    assert Aitch.respond_to?(:head)
    assert Aitch.respond_to?(:head!)
    assert Aitch.respond_to?(:options)
    assert Aitch.respond_to?(:options!)
    assert Aitch.respond_to?(:trace)
    assert Aitch.respond_to?(:trace!)
    assert Aitch.respond_to?(:execute)
    assert Aitch.respond_to?(:execute!)
    assert Aitch.respond_to?(:config)
    assert Aitch.respond_to?(:configuration)
  end
end
