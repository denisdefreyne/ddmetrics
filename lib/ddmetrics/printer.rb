# frozen_string_literal: true

module DDMetrics
  class Printer
    class Dataset
      def initialize(metric)
        @metric = metric
      end

      def transform(group_by:)
        raise ArgumentError unless block_given?

        group_by =
          case group_by
          when Array
            group_by
          when Symbol
            [group_by]
          when nil
            @metric.labels.flat_map(&:keys).uniq
          else
            raise ArgumentError
          end

        grouped_rows =
          @metric
          .group_by { |r| group_by.map { |g| r[0].fetch(g) } }

        grouped_stats =
          grouped_rows.map do |key, rows_in_group|
            values = rows_in_group.map(&:last)

            stats =
              if values.first.is_a?(DDMetrics::Stats)
                DDMetrics::Stats.new(values.flat_map(&:values))
              else
                DDMetrics::Stats.new(values)
              end

            [key, stats]
          end

        group_headers = nil
        rows =
          grouped_stats.map do |key, stats|
            hash = yield(stats)
            group_headers ||= hash.keys
            key.map(&:to_s) + hash.values.map(&:to_s)
          end

        header = group_by.map(&:to_s) + group_headers.map(&:to_s)
        [header] + rows
      end
    end

    def summary_to_s(summary, group_by:)
      rows = Dataset.new(summary).transform(group_by: group_by) do |stats|
        {
          'count': stats.count,
          'min':   format('%4.2f', stats.min),
          '.50':   format('%4.2f', stats.quantile(0.50)),
          '.90':   format('%4.2f', stats.quantile(0.90)),
          '.95':   format('%4.2f', stats.quantile(0.95)),
          'max':   format('%4.2f', stats.max),
          'tot':   format('%4.2f', stats.sum),
        }
      end

      DDMetrics::Table.new(rows, num_headers: rows[0].size - 7).to_s
    end

    def counter_to_s(counter, group_by:)
      rows = Dataset.new(counter).transform(group_by: group_by) do |stats|
        { count: stats.sum }
      end

      DDMetrics::Table.new(rows, num_headers: rows[0].size - 1).to_s
    end
  end
end
