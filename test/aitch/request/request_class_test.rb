# frozen_string_literal: true

require "test_helper"

class RequestClassTest < Minitest::Test
  test "raises with invalid method" do
    error = assert_raises(Aitch::InvalidHTTPMethodError) do
      build_request(request_method: "invalid").request
    end

    assert_equal %[unexpected HTTP verb: "invalid"], error.message
  end

  %w[
    get
    post
    put
    patch
    delete
    head
    options
    trace
  ].each do |method|
    test "instantiates #{method.upcase} method" do
      request = build_request(request_method: method).request

      assert_equal "Net::HTTP::#{method.capitalize}", request.class.name
    end
  end
end
