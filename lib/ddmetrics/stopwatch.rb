# frozen_string_literal: true

module DDMetrics
  class Stopwatch
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
      @duration = 0.0
      @last_start = nil
    end

    def start
      raise AlreadyRunningError if running?

      @last_start = Time.now
    end

    def stop
      raise NotRunningError unless running?

      @duration += (Time.now - @last_start)
      @last_start = nil
    end

    def duration
      raise StillRunningError if running?

      @duration
    end

    def running?
      !@last_start.nil?
    end

    def stopped?
      !running?
    end
  end
end
