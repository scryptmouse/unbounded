# encoding: utf-8

require 'active_support/concern'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/range'

require 'ostruct'

require 'unbounded/version'

# A library for working with unbounded (infinite) ranges,
# with support for PostgreSQL-style notation.
module Unbounded
  # Infinity
  INFINITY = 1.0 / 0.0

  # Negative infinity
  NINFINITY = -INFINITY

  autoload :Formats,            'unbounded/formats'
  autoload :InfiniteEnumerator, 'unbounded/infinite_enumerator'
  autoload :Range,              'unbounded/range'
  autoload :Utility,            'unbounded/utility'

  require 'unbounded/range_extension'

  # @!parse extend Unbounded::Utility
  extend Unbounded::Utility

  # @return [Unbounded::Range]
  def Unbounded.range(*args, &block)
    Unbounded::Range.new(*args, &block)
  end
end
