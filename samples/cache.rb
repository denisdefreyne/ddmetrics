# frozen_string_literal: true

require 'ddtelemetry'

class Cache
  attr_reader :counter

  def initialize
    @map = {}
    @counter = DDTelemetry::Counter.new
  end

  def []=(key, value)
    @counter.increment(type: :set)

    @map[key] = value
  end

  def [](key)
    if @map.key?(key)
      @counter.increment(type: :get_hit)
    else
      @counter.increment(type: :get_miss)
    end

    @map[key]
  end
end

cache = Cache.new

cache['greeting']
cache['greeting']
cache['greeting'] = 'Hi there!'
cache['greeting']
cache['greeting']
cache['greeting']

p cache.counter.get(type: :set)
# => 1

p cache.counter.get(type: :get_hit)
# => 3

p cache.counter.get(type: :get_miss)
# => 2

puts cache.counter
