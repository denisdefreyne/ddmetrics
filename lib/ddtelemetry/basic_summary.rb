# frozen_string_literal: true

module DDTelemetry
  class BasicSummary
    attr_reader :values

    def initialize
      @values = []
    end

    def observe(value)
      @values << value
    end
  end
end
