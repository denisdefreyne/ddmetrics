# frozen_string_literal: true

module DDTelemetry
  class Table
    def initialize(rows)
      @rows = rows
    end

    def to_s
      columns = @rows.transpose
      column_lengths = columns.map { |c| c.map(&:size).max }

      [].tap do |lines|
        lines << row_to_s(@rows[0], column_lengths)
        lines << separator(column_lengths)
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
      values[0] + ' │ ' + values[1..-1].join('   ')
    end

    def separator(column_lengths)
      (+'').tap do |s|
        s << '─' * column_lengths[0]
        s << '─┼─'
        s << column_lengths[1..-1].map { |l| '─' * l }.join('───')
      end
    end
  end
end
