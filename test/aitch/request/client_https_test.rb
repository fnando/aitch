# frozen_string_literal: true

require "test_helper"

class ClientHttpsTest < Minitest::Test
  let(:request) { build_request(url: "https://example.org") }
  let(:client) { request.client }

  test "sets https" do
    assert_predicate client, :use_ssl?
  end

  test "sets verification mode" do
    assert_equal OpenSSL::SSL::VERIFY_PEER, client.verify_mode
  end

  test "sets timeout" do
    request.options[:timeout] = 20

    assert_equal 20, client.read_timeout
  end
end
