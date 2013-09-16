# encoding: utf-8

module Unbounded
  # Methods for parsing alternative range formats
  # Presently there are two:
  #
  # * {POSTGRES_FORMAT}
  # * {SIMPLE_FORMAT}
  module Formats
    extend ActiveSupport::Concern

    # @!parse include Unbounded::Utility
    include Unbounded::Utility

    # A regular expression that loosely describes the format used within Postgres
    # for their range types. They look something like:
    #
    # * `"[4,6]"` == `4..6`
    # * `"[1,9)"` == `1...9`
    #
    # An endpoint can be omitted to create an unbounded type:
    #
    # * `"[1,]"` == `1..INFINITY`
    # * `"[,0)"` == `-INFINITY...0`
    #
    # @see http://www.postgresql.org/docs/9.2/static/rangetypes.html for more information
    # @return [Regexp] 
    POSTGRES_FORMAT=/^
      (?<lower_inc>[\[\(])
        (?<minimum>\S*)
          ,\s*
        (?<maximum>\S*)
      (?<upper_inc>[\)\]])
    $/x

    # A regular expression for parsing the simple format used in
    # Range.new shorthand, e.g. `'1..3'`, `'4...10'`
    # @return [Regexp]
    SIMPLE_FORMAT=/^(?<minimum>[^\.]+)(?<inclusiveness>\.\.\.?)(?<maximum>[^\.]+)$/

    # @param  [Array] args arguments from {Unbounded::Range#initialize}
    # @return [OpenStruct]
    def parse_for_range(args)
      hashed = case args.length
      when 0    then parse_standard_range_options(nil, nil)
      when 1    then parse_string_for_range_options(args.shift)
      when 2..3 then parse_standard_range_options(*args)
      end.presence or raise ArgumentError, "Don't know how to parse arguments: #{args.inspect}"


      OpenStruct.new(hashed).tap do |o|
        if o.format == :postgres
          alter_by_postgres_style! o
        elsif o.format == :simple
          alter_by_simple_style! o
        end
      end
    end

    private
    # Parse the standard range initialization options
    # @see Range#initialize
    # @param [Object] min
    # @param [Object] max
    # @param [Boolean] exclude_end
    # @return [{format: :standard, minimum: Numeric, maximum: Numeric, exclude_end: Boolean}]
    def parse_standard_range_options(min, max, exclude_end = false)
      {
        :format => :standard,
        :minimum => min.presence || NINFINITY,
        :maximum => max.presence || INFINITY,
        :exclude_end => !!exclude_end
      }
    end

    # Parse string using {POSTGRES_FORMAT} or {SIMPLE_FORMAT}.
    # @param  [#to_s] s
    # @return [Hash]
    def parse_string_for_range_options(s)
      case s.to_s
      when POSTGRES_FORMAT
        match_to_hash(Regexp.last_match).merge(:format => :postgres)
      when SIMPLE_FORMAT
        match_to_hash(Regexp.last_match).merge(:format => :simple)
      end
    end

    # Modify the options slightly for postgres formats.
    # @param [OpenStruct] options
    # @return [void]
    def alter_by_postgres_style!(options)
      options.minimum     = numerify(options.minimum, NINFINITY)
      options.maximum     = numerify(options.maximum, INFINITY)
      options.exclude_end = options.upper_inc == ')'

      if options.lower_inc == '('
        options.minimum += 1
      end
    end

    # Modify the options slightly to account for simple (e.g. 1..3) formatting
    # @param [OpenStruct] options
    # @return [void]
    def alter_by_simple_style!(options)
      options.minimum     = numerify(options.minimum, NINFINITY)
      options.maximum     = numerify(options.maximum, INFINITY)
      options.exclude_end = options.inclusiveness.length == 3
    end
  end
end
