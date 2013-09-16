# encoding: utf-8

module Unbounded
  # Extensions for the standard Ruby `Range` class.
  module RangeExtension
    extend ::ActiveSupport::Concern

    # @return [String] humanized string of the range
    def humanized
      "#{self.begin} \u2013 #{self.end}"
    end

    # Transform this into an Unbounded::Range.
    # @return [Unbounded::Range]
    def unbounded
      ::Unbounded::Range.new(self.min, self.max, exclude_end?)
    end
  end
end

Range.send(:include, Unbounded::RangeExtension)
