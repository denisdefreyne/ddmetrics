# frozen_string_literal: true

require_relative 'ddmetrics/version'

module DDMetrics
end

require_relative 'ddmetrics/basic_counter'
require_relative 'ddmetrics/basic_summary'

require_relative 'ddmetrics/metric'
require_relative 'ddmetrics/counter'
require_relative 'ddmetrics/summary'

require_relative 'ddmetrics/stopwatch'

require_relative 'ddmetrics/table'
require_relative 'ddmetrics/printer'
require_relative 'ddmetrics/stats'
