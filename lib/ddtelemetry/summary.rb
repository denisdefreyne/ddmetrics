# frozen_string_literal: true

module DDTelemetry
  class Summary
    def initialize
      @summaries = {}
    end

    def observe(value, label)
      get(label).observe(value)
    end

    def get(label)
      @summaries.fetch(label) { @summaries[label] = BasicSummary.new }
    end

    def map
      @summaries.map { |(label, summary)| yield(label, summary) }
    end

    def to_s
      DDTelemetry::Printer.new.summary_to_s(self)
    end
  end
end
