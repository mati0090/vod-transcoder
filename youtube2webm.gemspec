# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'youtube2webm/version'

Gem::Specification.new do |spec|
  spec.name          = "youtube2webm"
  spec.version       = Youtube2webm::VERSION
  spec.authors       = ["Bury"]
  spec.email         = ["mati0090@gmail.com"]
  spec.summary       = %q{Simple gem for creating webm clips from YouTube videos}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'viddl-rb', '~> 1.0.9'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
