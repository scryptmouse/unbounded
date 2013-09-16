# encoding: utf-8

require 'spec_helper'

shared_examples_for 'an infinite range' do
  it { should be_infinite }

  it_has_behavior 'humanized (infinite)'

  it 'it should include any number' do
    should include infinity, negative_infinity, *(positive_numbers + negative_numbers)
  end

  it_should_behave_like 'any unbounded range'
end
