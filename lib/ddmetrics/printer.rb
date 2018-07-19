# frozen_string_literal: true

module DDMetrics
  class Printer
    def summary_to_s(summary)
      table_for_summary(summary).to_s
    end

    def counter_to_s(counter)
      table_for_counter(counter).to_s
    end

    private

    def table_for_summary(summary)
      header_labels = nil
      headers = ['count', 'min', '.50', '.90', '.95', 'max', 'tot']

      rows = summary.labels.map do |label|
        header_labels ||= label.to_a.sort.map(&:first).map(&:to_s)
        stats = summary.get(label)

        count = stats.count
        min   = stats.min
        p50   = stats.quantile(0.50)
        p90   = stats.quantile(0.90)
        p95   = stats.quantile(0.95)
        tot   = stats.sum
        max   = stats.max

        label.to_a.sort.map(&:last).map(&:to_s) + [count.to_s] + [min, p50, p90, p95, max, tot].map { |r| format('%4.2f', r) }
      end

      DDMetrics::Table.new([header_labels + headers] + rows, num_headers: header_labels.size)
    end

    def table_for_counter(counter)
      header_labels = nil
      headers = ['count']

      rows = counter.labels.map do |label|
        header_labels ||= label.to_a.sort.map(&:first).map(&:to_s)
        label.to_a.sort.map(&:last).map(&:to_s) + [counter.get(label).to_s]
      end

      DDMetrics::Table.new([header_labels + headers] + rows, num_headers: header_labels.size)
    end
  end
end
