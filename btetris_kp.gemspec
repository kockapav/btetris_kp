# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'btetris_kp/version'

Gem::Specification.new do |spec|
  spec.name          = "btetris_kp"
  spec.version       = BTetrisKp::VERSION
  spec.authors       = ["Pavel Kocka"]
  spec.email         = ["kockapav@gmail.com"]
  spec.description   = %q{Battle Tetris}
  spec.summary       = %q{Tetris for 2 players via lan}
  spec.homepage      = "https://github.com/kockapav/btetris_kp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 0"
  spec.add_development_dependency "gosu", "~> 0.7"
  spec.add_development_dependency "rspec", "~> 2.14"
end
