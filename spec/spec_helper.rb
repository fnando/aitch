require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bundler/setup"
Bundler.require

require "aitch"
require "base64"
require "test_notifier/runner/rspec"
require "webmock/rspec"
require "nokogiri"

require_relative "support/webmock"
require_relative "support/request_uri"

RSpec.configure do |config|
  config.filter_run_excluding :ruby => -> version {
    !(RUBY_VERSION.to_s =~ /^#{version.to_s}/)
  }

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
