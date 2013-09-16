# encoding: utf-8

module Unbounded
  # An unbounded (infinite) range extension for the standard Ruby Range class.
  class Range < ::Range
    include Formats

    RANGE_FORMATS[:humanized] = proc { |first, last| ::Unbounded::Range.humanized(first, last) }
    RANGE_FORMATS[:postgres]  = proc { |first, last| ::Unbounded::Range.postgres(first, last) }

    # @overload initialize(range_start, range_minimum, exclude_end = false)
    #   Create a range the traditional way, à la `Range.new`.
    #   @param [#succ] range_start
    #   @param [#succ] range_end
    #   @param [Boolean] exclude_end
    # @overload initialize(range_string)
    #   Create a range in the same manner as you would in PostgreSQL
    #   @param [String] range_string
    def initialize(*args)
      parsed = parse_for_range(args)

      @format = parsed.format

      super(parsed.minimum, parsed.maximum, parsed.exclude_end)
    end

    # @todo i18n support
    # @return [String] a more human-readable format
    def humanized
      case unbounded?
      when :infinite
        "infinite"
      when :maximum
        "#{self.begin}+"
      when :minimum
        exclude_end? ? "fewer than #{self.end}" : "#{self.end} or fewer"
      else
        super
      end
    end

    # @return [Boolean]
    def infinite?
      numeric? && ( ( unbounded_minimum | unbounded_maximum ) == 3 )
    end

    # @return [Boolean] whether this range is numeric
    def numeric?
      self.begin.kind_of?(Numeric) && self.end.kind_of?(Numeric)
    end

    # For compatibility with {Unbounded::RangeExtension#unbounded}
    # unded?
    # @return [self]
    def unbounded
      self
    end

    # Check whether this range is unbounded in some way.
    # @return [Symbol,nil] returns a symbol for the type of unboundedness, nil otherwise
    def unbounded?(unbounded_type = nil)
      return false unless numeric?

      unboundedness = case unbounded_minimum | unbounded_maximum
      when 3 then :infinite
      when 2 then :maximum
      when 1 then :minimum
      end

      return unbounded_type && unboundedness ? ( unboundedness == :infinite ) || ( unboundedness == unbounded_type ) : unboundedness
    end

    # @!group Enumerable Overrides
    # Same as `Enumerable#count`, except in cases where the collection is {Range#unbounded?}.
    # @note This would not be true in some cases, e.g. checking for negative
    #   numbers on a range of 0 to infinity.
    # @return [Integer, INFINITY] Infinity when unbounded, super otherwise
    def count(*args, &block)
      unbounded? ? INFINITY : super
    end

    # @overload first
    #   @return [Numeric] equivalent to `#min`
    # @overload first(n)
    #   @param [Integer] n
    #   @return [Array<#succ>] first n-elements of the range
    def first(*args)
      n = args.shift

      if unbounded_minimum? && (n.nil? || n.kind_of?(Integer))
        if n.nil?
          min
        else
          Array.new(n, min)
        end
      else
        return n.nil? ? super() : super(n)
      end
    end

    # @overload last
    #   @return [Numeric] equivalent to {#max}
    # @overload last(n)
    #   @param  [Integer] n
    #   @return [Array<#succ>] last n-elements of the range
    def last(*args)
      n = args.shift

      if unbounded? && (n.nil? || n.kind_of?(Integer))
        if n.nil?
          max
        elsif unbounded? == :minimum # To prevent `cannot iterate from Float`
          new_minimum = max - (n - 1)

          (new_minimum..max).to_a
        else
          Array.new(n, max) # Array of Infinity
        end
      else
        return n.nil? ? super() : super(n)
      end
    end

    # Overload for `Range#max` to account for "unbounded_maximum? && exclude_end?" edge case
    def max
      super
    rescue TypeError
      self.end
    end

    # The default implementation of `Range#minmax` for needlessly uses `#each`,
    # which can cause infinite enumeration.
    # @return [Array(Numeric, Numeric)]
    def minmax
      [min, unbounded? ? INFINITY : max]
    end
    # @!endgroup

    class << self
      # @param [Numeric] first
      # @param [Numeric] last
      # @return [String]
      def humanized(first, last)
        return new(first, last).humanized
      end

      private
      # @param [Symbol] type should be :min or :max
      # @param [Integer] int_to_return integer to return for bitwise comparison in {#unbounded?}
      # @return [void]
      # @!macro [attach] unbounded_endpoint
      #   @!method unbounded_$1imum
      #     Determine whether the $1 is unbounded.
      #     @!visibility private
      #     @return [$2,0] $2 if unbounded, 0 if otherwise
      #
      #   @!method unbounded_$1imum?
      #     Predicate method for {#unbounded_$1imum} that checks against zero
      #     @return [Integer,nil]
      #
      #   @!method finite_$1imum?
      #     Inverse complement of {#unbounded_$1imum?}
      #     @return [Boolean]
      def unbounded_endpoint(type, int_to_return)
        attr_name = type == :min ? "begin" : "end"

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def unbounded_#{type}imum
            self.#{attr_name}.respond_to?(:infinite?) && self.#{attr_name}.infinite? ? #{int_to_return} : 0
          end

          def unbounded_#{type}imum?
            unbounded_#{type}imum.nonzero?
          end

          def finite_#{type}imum?
            !unbounded_#{type}imum?
          end

          private :unbounded_#{type}imum
        RUBY
      end
    end

    unbounded_endpoint :min, 1
    unbounded_endpoint :max, 2
  end
end
