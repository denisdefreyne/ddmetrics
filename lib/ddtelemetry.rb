# frozen_string_literal: true

require_relative 'ddtelemetry/version'

module DDTelemetry
  def self.new
    Registry.new
  end
end

require_relative 'ddtelemetry/counter'
require_relative 'ddtelemetry/summary'

require_relative 'ddtelemetry/labelled_counter'
require_relative 'ddtelemetry/labelled_summary'

require_relative 'ddtelemetry/registry'
require_relative 'ddtelemetry/stopwatch'

require_relative 'ddtelemetry/table'
