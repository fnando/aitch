# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  test "sets default timeout" do
    assert_equal 10, Aitch::Configuration.new.timeout
  end

  test "sets default user agent" do
    user_agent = "Aitch/#{Aitch::VERSION} (http://rubygems.org/gems/aitch)"

    assert_equal user_agent, Aitch::Configuration.new.user_agent
  end

  test "sets default maximum redirections" do
    assert_equal 5, Aitch::Configuration.new.redirect_limit
  end

  test "sets default headers" do
    assert_empty(Aitch::Configuration.new.default_headers)
  end

  test "configures aitch" do
    Aitch.configure do |config|
      config.timeout = 15
    end

    assert_equal 15, Aitch.configuration.timeout
  end
end
