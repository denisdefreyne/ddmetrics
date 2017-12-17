# frozen_string_literal: true

require 'ddtelemetry'

class Cache
  def initialize(telemetry)
    @telemetry = telemetry
    @map = {}
  end

  def []=(key, value)
    @telemetry.counter(:cache).increment(:set)

    @map[key] = value
  end

  def [](key)
    if @map.key?(key)
      @telemetry.counter(:cache).increment(%i[get hit])
    else
      @telemetry.counter(:cache).increment(%i[get miss])
    end

    @map[key]
  end
end

telemetry = DDTelemetry::Registry.new
cache = Cache.new(telemetry)

cache['greeting']
cache['greeting']
cache['greeting'] = 'Hi there!'
cache['greeting']
cache['greeting']
cache['greeting']

p telemetry.counter(:cache).value(:set)
# => 1

p telemetry.counter(:cache).value(%i[get hit])
# => 3

p telemetry.counter(:cache).value(%i[get miss])
# => 2
