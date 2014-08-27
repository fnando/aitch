require "bundler/setup"
Bundler.require

require "aitch"
require "base64"
require "test_notifier/runner/rspec"
require "fakeweb"
require "nokogiri"

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.filter_run_excluding :ruby => -> version {
    !(RUBY_VERSION.to_s =~ /^#{version.to_s}/)
  }

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
