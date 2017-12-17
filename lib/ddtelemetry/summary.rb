# frozen_string_literal: true

module DDTelemetry
  class Summary < Metric
    def observe(value, label)
      basic_metric_for(label, BasicSummary).observe(value)
    end

    def get(label)
      values = basic_metric_for(label, BasicSummary).values
      DDTelemetry::Stats.new(values)
    end

    def to_s
      DDTelemetry::Printer.new.summary_to_s(self)
    end
  end
end
