require "bundler/setup"
Bundler.require

require "aitch"
require "base64"
require "test_notifier/runner/rspec"
require "fakeweb"
require "nokogiri"

FakeWeb.allow_net_connect = false
