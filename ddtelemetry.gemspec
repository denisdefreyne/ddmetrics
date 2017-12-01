# frozen_string_literal: true

require_relative 'lib/ddtelemetry/version'

Gem::Specification.new do |spec|
  spec.name          = 'ddtelemetry'
  spec.version       = DDTelemetry::VERSION
  spec.authors       = ['Denis Defreyne']
  spec.email         = ['denis+rubygems@denis.ws']

  spec.summary       = 'Non-timeseries telemetry'
  spec.homepage      = 'https://github.com/ddfreyne/ddtelemetry'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.3.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']
end
