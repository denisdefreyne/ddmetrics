# frozen_string_literal: true

module DDMetrics
  class Counter < Metric
    def increment(label)
      validate_label(label)
      basic_metric_for(label, BasicCounter).increment
    end

    def get(label)
      validate_label(label)
      basic_metric_for(label, BasicCounter).value
    end

    def to_s
      DDMetrics::Printer.new.counter_to_s(self)
    end
  end
end
