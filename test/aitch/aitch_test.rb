# frozen_string_literal: true

require "test_helper"

class AitchTest < Minitest::Test
  test "defines public API" do
    assert_respond_to Aitch, :get
    assert_respond_to Aitch, :get!
    assert_respond_to Aitch, :post
    assert_respond_to Aitch, :post!
    assert_respond_to Aitch, :put
    assert_respond_to Aitch, :put!
    assert_respond_to Aitch, :patch
    assert_respond_to Aitch, :patch!
    assert_respond_to Aitch, :delete
    assert_respond_to Aitch, :delete!
    assert_respond_to Aitch, :head
    assert_respond_to Aitch, :head!
    assert_respond_to Aitch, :options
    assert_respond_to Aitch, :options!
    assert_respond_to Aitch, :trace
    assert_respond_to Aitch, :trace!
    assert_respond_to Aitch, :execute
    assert_respond_to Aitch, :execute!
    assert_respond_to Aitch, :config
    assert_respond_to Aitch, :configuration
  end
end
