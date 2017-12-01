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
telemetry = DDTelemetry::Registry.new
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

TODO

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
