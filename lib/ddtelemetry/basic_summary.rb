# frozen_string_literal: true

module DDTelemetry
  class BasicSummary
    def initialize
      @values = []
    end

    def observe(value)
      @values << value
      @sorted_values = nil
    end

    def count
      stats.count
    end

    def sum
      stats.sum
    end

    def avg
      stats.avg
    end

    def min
      stats.min
    end

    def max
      stats.max
    end

    def quantile(fraction)
      stats.quantile(fraction)
    end

    private

    def updated
      @_stats = nil
    end

    def stats
      @_stats ||= DDTelemetry::Stats.new(@values)
    end
  end
end
