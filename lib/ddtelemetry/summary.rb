# frozen_string_literal: true

module DDTelemetry
  class Summary
    def initialize
      @summaries = {}
    end

    def observe(value, label)
      basic_summary_for(label).observe(value)
    end

    def get(label)
      values = basic_summary_for(label).values
      DDTelemetry::Stats.new(values)
    end

    def labels
      @summaries.keys
    end

    def to_s
      DDTelemetry::Printer.new.summary_to_s(self)
    end

    # @api private
    def basic_summary_for(label)
      @summaries.fetch(label) { @summaries[label] = BasicSummary.new }
    end
  end
end
