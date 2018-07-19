# frozen_string_literal: true

module DDMetrics
  class Table
    def initialize(rows, num_headers: 1)
      @rows = rows
      @num_headers = num_headers
    end

    def to_s
      columns = @rows.transpose
      column_lengths = columns.map { |c| c.map(&:size).max }

      [].tap do |lines|
        # header
        lines << row_to_s(@rows[0], column_lengths)

        # separator
        lines << separator(column_lengths)

        # body
        rows = sort_rows(@rows.drop(1))
        lines.concat(rows.map { |r| row_to_s(r, column_lengths) })
      end.join("\n")
    end

    private

    def sort_rows(rows)
      rows.sort_by { |r| r.first.downcase }
    end

    def row_to_s(row, column_lengths)
      values = row.zip(column_lengths).map { |text, length| text.rjust(length) }
      values.take(@num_headers).join('   ') + ' │ ' + values.drop(@num_headers).join('   ')
    end

    def separator(column_lengths)
      (+'').tap do |s|
        s << column_lengths.take(@num_headers).map { |l| '─' * l }.join('───')
        s << '─┼─'
        s << column_lengths.drop(@num_headers).map { |l| '─' * l }.join('───')
      end
    end
  end
end
