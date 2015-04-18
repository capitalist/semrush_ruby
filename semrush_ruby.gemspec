# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'semrush_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "semrush_ruby"
  spec.version       = SemrushRuby::VERSION
  spec.authors       = ["Joe Martinez"]
  spec.email         = ["joe@joemartinez.name"]

  spec.summary       = %q{Idiomatic Ruby Client for the SEMRush API}
  spec.description   = %q{Idiomatic Ruby Client for the SEMRush API}
  spec.homepage      = "https://www.github.com/capitalist/semrush_ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday_middleware', "0.9.1"
  spec.add_dependency 'multi_json'
  spec.add_dependency 'hashie'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "awesome_print"
end
