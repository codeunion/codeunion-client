# encoding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "codeunion/version"

Gem::Specification.new do |spec|
  spec.name          = "codeunion"
  spec.version       = CodeUnion::VERSION
  spec.authors       = ["Jesse Farmer"]
  spec.email         = ["jesse@codeunion.io"]
  spec.summary       = %q{The CodeUnion Command-Line Tool}
  spec.description   = %q{The CodeUnion command-line tool helps students work through CodeUnion's curriculum.}
  spec.homepage      = "http://github.com/codeunion/codeunion-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "ptools", "~> 1.2"
end
