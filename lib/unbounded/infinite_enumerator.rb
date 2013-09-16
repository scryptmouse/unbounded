# encoding: utf-8

module Unbounded
  # An error created when attempting to iterate over a (non-lazy)
  # version of an {Unbounded::Range}, and the current ruby version
  # does not support `#lazy`.

  class InfiniteEnumerator < TypeError
  end
end
