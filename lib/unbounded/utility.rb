# encoding: utf-8

module Unbounded
  # Shared utility methods
  module Utility
    extend ActiveSupport::Concern

    # Convert matchdata to a hash.
    # @param [MatchData] match
    # @return [Hash]
    def match_to_hash(match)
      Hash[match.names.zip(match.captures)]
    end

    # @param [Object] thing something to numerify
    # @param [Object] default_value a value to return if `thing` fails to numerify.
    #   If it is `:original`, it will return the value of `thing` as-is.
    # @return [Numeric, Object, nil]
    def numerify(thing, default_value = nil)
      return thing if thing.is_a?(Numeric)

      if thing.respond_to?(:include?) && thing.include?('.')
        Float(thing)
      else
        Integer(thing)
      end
    rescue ArgumentError, TypeError
      if default_value == :original
        thing
      else
        default_value
      end
    end

    extend self
  end
end
