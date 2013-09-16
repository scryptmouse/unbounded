# encoding: utf-8

require 'spec_helper'

describe Unbounded do
  describe '.range' do
    specify 'creates a range' do
      described_class.range(nil, nil).should be_a_kind_of Unbounded::Range
    end
  end
end
