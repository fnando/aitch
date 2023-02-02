# frozen_string_literal: true

require "test_helper"

class DslTest < Minitest::Test
  let(:dsl) { Aitch::DSL.new }

  test "sets url" do
    dsl.url "URL"

    assert_equal "URL", dsl.url
  end

  test "sets options" do
    dsl.options "OPTIONS"

    assert_equal "OPTIONS", dsl.options
  end

  test "sets headers" do
    dsl.headers "HEADERS"

    assert_equal "HEADERS", dsl.headers
  end

  test "sets data" do
    dsl.data "DATA"

    assert_equal "DATA", dsl.data
  end

  test "sets data through params" do
    dsl.params "PARAMS"

    assert_equal "PARAMS", dsl.data
  end

  test "sets data through body" do
    dsl.body "BODY"

    assert_equal "BODY", dsl.data
  end

  test "returns hash" do
    dsl.options "OPTIONS"
    dsl.headers "HEADERS"
    dsl.url "URL"
    dsl.data "DATA"

    assert_equal "DATA", dsl.to_h[:data]
    assert_equal "HEADERS", dsl.to_h[:headers]
    assert_equal "URL", dsl.to_h[:url]
    assert_equal "OPTIONS", dsl.to_h[:options]
  end
end
