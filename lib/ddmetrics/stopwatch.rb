# frozen_string_literal: true

module DDMetrics
  class Stopwatch
    NANOS_PER_SECOND = 1_000_000_000

    class AlreadyRunningError < StandardError
      def message
        'Cannot start, because stopwatch is already running'
      end
    end

    class NotRunningError < StandardError
      def message
        'Cannot stop, because stopwatch is not running'
      end
    end

    class StillRunningError < StandardError
      def message
        'Cannot get duration, because stopwatch is still running'
      end
    end

    def initialize
      @duration = 0
      @last_start = nil
    end

    def run
      start
      yield
    ensure
      stop
    end

    def start
      raise AlreadyRunningError if running?

      @last_start = nanos_now
    end

    def stop
      raise NotRunningError unless running?

      @duration += (nanos_now - @last_start)
      @last_start = nil
    end

    def duration
      raise StillRunningError if running?

      @duration.to_f / NANOS_PER_SECOND
    end

    def running?
      !@last_start.nil?
    end

    def stopped?
      !running?
    end

    private

    def nanos_now
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
    end
  end
end
