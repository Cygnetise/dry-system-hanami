# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dry/system/hanami/version"

Gem::Specification.new do |spec|
  spec.name          = "dry-system-hanami"
  spec.version       = Dry::System::Hanami::VERSION
  spec.authors       = ["Anton Davydov"]
  spec.email         = ["antondavydov.o@gmail.com"]

  spec.summary       = %q{Folder resolver for dry-system in hanami projects}
  spec.description   = %q{Folder resolver for dry-system in hanami projects}
  spec.homepage      = 'https://github.com/davydovanton/dry-system-hanami'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
