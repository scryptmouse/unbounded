# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unbounded/version'

Gem::Specification.new do |spec|
  spec.name          = "unbounded"
  spec.version       = Unbounded::VERSION
  spec.authors       = ["Alexa Grey"]
  spec.email         = ["devel@mouse.vc"]
  spec.description   = %q{Unbounded (infinite) ranges, ruby-style}
  spec.summary       = %q{Unbounded (infinite) ranges, ruby-style}
  spec.homepage      = "https://github.com/scryptmouse/unbounded"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", '>= 3.0.0'

  spec.add_development_dependency "bundler",  "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",    "~> 2.14"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency 'yard'
end
