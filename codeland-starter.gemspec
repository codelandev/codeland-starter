# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'codeland/starter/version'

Gem::Specification.new do |spec|
  spec.name          = 'codeland-starter'
  spec.version       = Codeland::Starter::VERSION
  spec.authors       = ['Sérgio Schnorr Júnior']
  spec.email         = %w(jr.schnorr@gmail.com)
  spec.summary       = 'Codeland starter. To create services in just one time'
  spec.homepage      = 'https://github.com/codelandev/codeland-starter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(bin lib)
  spec.bindir = 'bin'

  spec.add_runtime_dependency 'platform-api'
  spec.add_runtime_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'webmock', '~> 1.19.0'
  spec.add_development_dependency 'simplecov', '~> 0.9.0'
  spec.add_development_dependency 'simplecov-console'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4.0'
end
