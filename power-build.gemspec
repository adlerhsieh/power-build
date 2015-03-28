# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'power-build/version'

Gem::Specification.new do |spec|
  spec.name          = "power-build"
  spec.version       = PowerBuild::VERSION
  spec.authors       = ["Adler"]
  spec.email         = ["nkj20932@hotmail.com"]
  spec.summary       = %q{A simple photo album site generator.}
  spec.description   = %q{A site generator for hosting a photo album on github.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = "power"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "thor", "~> 0.19"
  spec.add_development_dependency "colorize", "~> 0"
end
