# frozen_string_literal: true

require_relative 'lib/ddmetrics/version'

Gem::Specification.new do |spec|
  spec.name          = 'ddmetrics'
  spec.version       = DDMetrics::VERSION
  spec.authors       = ['Denis Defreyne']
  spec.email         = ['denis+rubygems@denis.ws']

  spec.summary       = 'Non-timeseries measurements for Ruby programs'
  spec.homepage      = 'https://github.com/ddfreyne/ddmetrics'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.3.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']
end
