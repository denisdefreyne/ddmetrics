# frozen_string_literal: true

module DDTelemetry
  class Metric
    def initialize
      @basic_metrics = {}
    end

    def get(label)
      basic_metric_for(label, BasicCounter)
    end

    def labels
      @basic_metrics.keys
    end

    def each
      @basic_metrics.each_key do |label|
        yield(label, get(label))
      end
    end

    # @api private
    def basic_metric_for(label, basic_class)
      @basic_metrics.fetch(label) { @basic_metrics[label] = basic_class.new }
    end
  end
end
