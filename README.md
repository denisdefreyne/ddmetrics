[![Gem version](https://img.shields.io/gem/v/ddtelemetry.svg)](http://rubygems.org/gems/ddtelemetry)
[![Gem downloads](https://img.shields.io/gem/dt/ddtelemetry.svg)](http://rubygems.org/gems/ddtelemetry)
[![Build status](https://img.shields.io/travis/ddfreyne/ddtelemetry.svg)](https://travis-ci.org/ddfreyne/ddtelemetry)
[![Code Climate](https://img.shields.io/codeclimate/github/ddfreyne/ddtelemetry.svg)](https://codeclimate.com/github/ddfreyne/ddtelemetry)
[![Code Coverage](https://img.shields.io/codecov/c/github/ddfreyne/ddtelemetry.svg)](https://codecov.io/gh/ddfreyne/ddtelemetry)

# DDTelemetry

_DDTelemetry_ provides in-process, non-timeseries telemetry for short-running Ruby processes.

⚠️ This project is **experimental** and should not be used in production yet.

If you are looking for a full-featured timeseries monitoring system, look no further than [Prometheus](https://prometheus.io/).

## Example

Take the following (naïve) cache implementation as a starting point:

```ruby
class Cache
  def initialize
    @map = {}
  end

  def []=(key, value)
    @map[key] = value
  end

  def [](key)
    @map[key]
  end
end
```

To start instrumenting this code, require `ddtelemetry`, pass a telemetry instance into the constructor, and record some metrics:

```ruby
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
      @telemetry.counter(:cache).increment([:get, :hit])
    else
      @telemetry.counter(:cache).increment([:get, :miss])
    end

    @map[key]
  end
end
```

Let’s construct a cache (with telemetry) and exercise it:

```ruby
telemetry = DDTelemetry.new
cache = Cache.new(telemetry)

cache['greeting']
cache['greeting']
cache['greeting'] = 'Hi there!'
cache['greeting']
cache['greeting']
cache['greeting']
```

Finally, print the recorded telemetry values:

```ruby
p telemetry.counter(:cache).value(:set)
# => 1

p telemetry.counter(:cache).value([:get, :hit])
# => 3

p telemetry.counter(:cache).value([:get, :miss])
# => 2
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ddtelemetry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ddtelemetry

## Usage

_DDTelemetry_ provides two metric types:

* A **counter** is an integer metric that only ever increases. Examples: cache hits, number of files written, …

* A **summary** records observations, and provides functionality for describing the distribution of the observations through quantiles. Examples: outgoing request durations, size of written files, …

Each metric is recorded with a label, which is a free-form object that is useful to further refine the kind of data that is being recorded. For example:

```ruby
telemetry.counter(:cache_hits).increment(:file_cache)
telemetry.summary(:request_durations).observe(:weather_api, 1.07)
```

NOTE: Labels will likely change to become key-value pairs in a future version of DDTelemetry.

### Counters

A counter is created using `#counter`, passing in the name of the counter:

```ruby
telemetry = DDTelemetry.new
counter = telemetry.counter(:cache_hits)
```

To increment a counter, call `#increment` with a label:

```ruby
counter.increment(:file_cache)
```

### Summaries

A summary is created using `#summary`, passing in the name of the summary:

```ruby
telemetry = DDTelemetry.new
summary = telemetry.summary(:request_durations)
```

To observe a value, call `#observe` with a label, along with the value to observe:

```ruby
summary.observe(:weather_api, 1.07)
```

## Printing metrics

To print a metric, use `#to_s`. For example:

```ruby
puts summary
```

Output:

```
     │ count     min     .50     .90     .95     max     tot
─────┼──────────────────────────────────────────────────────
 erb │     2   2.10s   3.10s   3.90s   4.00s   4.10s   6.20s
haml │     1   5.30s   5.30s   5.30s   5.30s   5.30s   5.30s
```

### Stopwatch

The `DDTelemetry::Stopwatch` class can be used to measure durations. Use `#start` and `#stop` to start and stop the stopwatch, respectively, and `#duration` to read the value of the stopwatch:

```ruby
stopwatch = DDTelemetry::Stopwatch.new

stopwatch.start
sleep 1
stopwatch.stop
puts "That took #{stopwatch.duration}s."
# Output: That took 1.006831s.
```

A stopwatch, once created, will never reset its duration. Running the stopwatch again will add to the existing duration:

```ruby
stopwatch.start
sleep 1
stopwatch.stop
puts "That took #{stopwatch.duration}s."
# Output: That took 2.012879s.
```

You can query whether or not a stopwatch is running using `#running?`; `#stopped?` is the opposite of `#running?`.

## Development

Install dependencies:

    $ bundle

Run tests:

    $ bundle exec rake

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ddfreyne/ddtelemetry. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DDTelemetry project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ddfreyne/ddtelemetry/blob/master/CODE_OF_CONDUCT.md).
