# frozen_string_literal: true
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bundler/setup"

require "minitest/utils"
require "minitest/autorun"

require "aitch"

require "base64"
require "nokogiri"

require_relative "support/helpers"
