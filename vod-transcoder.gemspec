# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vod-transcoder/version'

Gem::Specification.new do |spec|
  spec.name          = "vod-transcoder"
  spec.version       = VodTranscoder::VERSION
  spec.authors       = ["Bury"]
  spec.email         = ["mati0090@gmail.com"]
  spec.summary       = %q{Simple gem for transcoding clips from VOD services like Youtube, Vimeo.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'viddl-rb', '~> 1.0.9'
  spec.add_dependency 'typhoeus', '~> 0.7'
  spec.add_dependency 'streamio-ffmpeg', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
