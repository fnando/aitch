# frozen_string_literal: true

require "./lib/aitch/version"

Gem::Specification.new do |spec|
  spec.name          = "aitch"
  spec.version       = Aitch::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["me@fnando.com"]
  spec.description   = "A simple HTTP client"
  spec.summary       = spec.description
  spec.homepage      = "http://rubygems.org/gems/aitch"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-fnando"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock"
end
