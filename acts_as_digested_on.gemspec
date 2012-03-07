# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_digested_on/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_digested_on"
  s.version     = ActsAsDigestedOn::VERSION
  s.authors     = ["milk1000cc"]
  s.email       = ["info@milk1000.cc"]
  s.homepage    = "https://github.com/milk1000cc/acts_as_digested_on"
  s.summary     = %q{Automatically set sha-1 hex digest}
  s.description = %q{This gem sets the digested value before validation and validates uniqueness of the digested value.}

  s.rubyforge_project = "acts_as_digested_on"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "rails", ">= 3.0.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
end
