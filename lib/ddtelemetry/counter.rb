# frozen_string_literal: true

module DDTelemetry
  class Counter
    def initialize
      @counters = {}
    end

    def increment(label)
      basic_counter_for(label).increment
    end

    def get(label)
      basic_counter_for(label).value
    end

    def map
      @counters.map { |(label, counter)| yield(label, counter) }
    end

    def to_s
      DDTelemetry::Printer.new.counter_to_s(self)
    end

    # @api private
    def basic_counter_for(label)
      @counters.fetch(label) { @counters[label] = BasicCounter.new }
    end
  end
end
