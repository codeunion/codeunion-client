# encoding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "codeunion/version"

Gem::Specification.new do |spec|
  spec.name          = "codeunion"
  spec.version       = CodeUnion::VERSION
  spec.authors       = ["Jesse Farmer"]
  spec.email         = ["jesse@codeunion.io"]
  spec.summary       = "The CodeUnion Command-Line Tool"
  spec.description   = "The CodeUnion command-line tool helps students work through CodeUnion's curriculum."
  spec.homepage      = "http://github.com/codeunion/codeunion-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.27"
  spec.add_development_dependency "minitest", "~> 5.5"

  spec.add_dependency "ptools", "~> 1.2"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "faraday_middleware", "~> 0.9"
  spec.add_dependency "addressable", "~> 2.3"
  spec.add_dependency "multi_json", "~> 1.10"
  spec.add_dependency "rainbow", "~> 2.0"
end
