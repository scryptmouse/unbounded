# Unbounded
[![Build Status](https://travis-ci.org/scryptmouse/unbounded.png)](https://travis-ci.org/scryptmouse/unbounded)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unbounded'
```

And then execute:

```shell
bundle
```

Or install it yourself as:

```shell
gem install unbounded
```

## Usage

Create an unbounded range by passing nil as one of the end points:

```ruby
normal_style = Unbounded::Range.new(0, nil) # => 0..INFINITY
```

... Or using postgres-style ranges

```ruby
postgres_style = Unbounded::Range.new('[0,100)') # => 0...100
```

Alternatively, convert a vanilla range:

```ruby
converted = (1..3).unbounded
converted.kind_of? Unbounded::Range # => true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Todo

* invertable ranges (at least for numeric)

