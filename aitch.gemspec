require "./lib/aitch/version"

Gem::Specification.new do |spec|
  spec.name          = "aitch"
  spec.version       = Aitch::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.description   = "A simple HTTP client"
  spec.summary       = spec.description
  spec.homepage      = "http://rubygems.org/gems/aitch"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", ">= 1.6.0"

  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "test_notifier"
  spec.add_development_dependency "webmock"
end
