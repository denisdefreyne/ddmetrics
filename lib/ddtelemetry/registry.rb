# frozen_string_literal: true

module DDTelemetry
  class Registry
    def initialize
      @counters = {}
      @summaries = {}
    end

    def counter(name)
      @counters.fetch(name) { @counters[name] = Counter.new }
    end

    def summary(name)
      @summaries.fetch(name) { @summaries[name] = Summary.new }
    end
  end
end
