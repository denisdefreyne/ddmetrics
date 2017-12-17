# frozen_string_literal: true

module DDTelemetry
  class Counter
    def initialize
      @counters = {}
    end

    def increment(label)
      get(label).increment
    end

    def get(label)
      @counters.fetch(label) { @counters[label] = BasicCounter.new }
    end

    def map
      @counters.map { |(label, counter)| yield(label, counter) }
    end

    def to_s
      DDTelemetry::Printer.new.counter_to_s(self)
    end
  end
end
