# frozen_string_literal: true

module DDMetrics
  class Printer
    def summary_to_s(summary)
      DDMetrics::Table.new(table_for_summary(summary)).to_s
    end

    def counter_to_s(counter)
      DDMetrics::Table.new(table_for_counter(counter)).to_s
    end

    private

    def label_to_s(label)
      label.to_a.sort.map { |pair| pair.join('=') }.join(' ')
    end

    def table_for_summary(summary)
      headers = ['', 'count', 'min', '.50', '.90', '.95', 'max', 'tot']

      rows = summary.labels.map do |label|
        stats = summary.get(label)

        count = stats.count
        min   = stats.min
        p50   = stats.quantile(0.50)
        p90   = stats.quantile(0.90)
        p95   = stats.quantile(0.95)
        tot   = stats.sum
        max   = stats.max

        [label_to_s(label), count.to_s] + [min, p50, p90, p95, max, tot].map { |r| format('%4.2f', r) }
      end

      [headers] + rows
    end

    def table_for_counter(counter)
      headers = ['', 'count']

      rows = counter.labels.map do |label|
        [label_to_s(label), counter.get(label).to_s]
      end

      [headers] + rows
    end
  end
end
