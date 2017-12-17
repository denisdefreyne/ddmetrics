# frozen_string_literal: true

module DDTelemetry
  class Stats
    class EmptyError < StandardError
      def message
        'Not enough data to perform calculation'
      end
    end

    def initialize(values)
      @values = values
    end

    def inspect
      "<#{self.class} count=#{count}>"
    end

    def count
      @values.size
    end

    def sum
      raise EmptyError if @values.empty?
      @values.reduce(:+)
    end

    def avg
      sum.to_f / count
    end

    def min
      quantile(0.0)
    end

    def max
      quantile(1.0)
    end

    def quantile(fraction)
      raise EmptyError if @values.empty?

      target = (@values.size - 1) * fraction.to_f
      interp = target % 1.0
      sorted_values[target.floor] * (1.0 - interp) + sorted_values[target.ceil] * interp
    end

    private

    def sorted_values
      @sorted_values ||= @values.sort
    end
  end
end
