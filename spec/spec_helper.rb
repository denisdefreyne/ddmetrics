# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'ddmetrics'

require 'fuubar'
require 'rspec/its'
require 'timecop'

RSpec.configure do |c|
  c.fuubar_progress_bar_options = {
    format: '%c/%C |<%b>%i| %p%%',
  }
end
