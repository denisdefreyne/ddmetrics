# frozen_string_literal: true

module DDTelemetry
  class Counter < Metric
    def increment(label)
      basic_metric_for(label, BasicCounter).increment
    end

    def get(label)
      basic_metric_for(label, BasicCounter).value
    end

    def to_s
      DDTelemetry::Printer.new.counter_to_s(self)
    end
  end
end
