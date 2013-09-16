# encoding: utf-8

require 'spec_helper'

shared_examples_for 'any unbounded range' do
  it { should be_unbounded }

  it { should be_numeric }

  describe '#count' do
    its(:count) { should be_infinite }
  end
end
