# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  test "sets default timeout" do
    assert_equal 10, Aitch::Configuration.new.timeout
  end

  test "sets default retries" do
    assert_equal 1, Aitch::Configuration.new.retries
  end

  test "sets default user agent" do
    user_agent = "Aitch/#{Aitch::VERSION} (http://rubygems.org/gems/aitch)"

    assert_equal user_agent, Aitch::Configuration.new.user_agent
  end

  test "sets default maximum redirections" do
    assert_equal 5, Aitch::Configuration.new.redirect_limit
  end

  test "sets default headers" do
    config = Aitch::Configuration.new
    config.default_headers = {content_type: "application/json"}

    assert_equal({"content-type" => "application/json"}, config.default_headers.to_h)
  end

  test "configures aitch" do
    Aitch.configure do |config|
      config.timeout = 15
    end

    assert_equal 15, Aitch.configuration.timeout
  end
end
