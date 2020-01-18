# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "bundler/setup"

require "minitest/utils"
require "minitest/autorun"

require "aitch"

require "base64"
require "nokogiri"

require_relative "support/helpers"
