# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_digested_on/version'

Gem::Specification.new do |spec|
  spec.name          = "acts_as_digested_on"
  spec.version       = ActsAsDigestedOn::VERSION
  spec.authors       = ["milk1000cc"]
  spec.email         = ["info@milk1000.cc"]
  spec.summary       = %q{Automatically set sha-1 hex digest}
  spec.description   = %q{This gem sets the digested value before validation and validates uniqueness of the digested value.}
  spec.homepage      = "https://github.com/milk1000cc/acts_as_digested_on"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '>= 3.0.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
