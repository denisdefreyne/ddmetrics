# frozen_string_literal: true

module DDTelemetry
  class Printer
    def summary_to_s(summary)
      DDTelemetry::Table.new(table_for_summary(summary)).to_s
    end

    def counter_to_s(counter)
      DDTelemetry::Table.new(table_for_counter(counter)).to_s
    end

    private

    def table_for_summary(labelled_summary)
      headers = ['', 'count', 'min', '.50', '.90', '.95', 'max', 'tot']

      rows = labelled_summary.map do |label, summary|
        stats = DDTelemetry::Stats.new(summary.values)

        count = stats.count
        min   = stats.min
        p50   = stats.quantile(0.50)
        p90   = stats.quantile(0.90)
        p95   = stats.quantile(0.95)
        tot   = stats.sum
        max   = stats.max

        [label.to_s, count.to_s] + [min, p50, p90, p95, max, tot].map { |r| format('%4.2f', r) }
      end

      [headers] + rows
    end

    def table_for_counter(labelled_counter)
      headers = ['', 'count']

      rows = labelled_counter.map do |label, counter|
        [label.to_s, counter.value.to_s]
      end

      [headers] + rows
    end
  end
end
