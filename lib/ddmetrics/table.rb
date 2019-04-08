# frozen_string_literal: true

require 'tty-table'

module DDMetrics
  class Table
    def initialize(rows, num_headers: 1)
      @rows = rows
      @num_headers = num_headers
    end

    def to_s
      table = TTY::Table.new(header: @rows[0], rows: sort_rows(@rows.drop(1)))
      table.render(:unicode, padding: [0, 1, 0, 1])
    end

    private

    def sort_rows(rows)
      rows.sort_by { |r| r.first.downcase }
    end
  end
end
