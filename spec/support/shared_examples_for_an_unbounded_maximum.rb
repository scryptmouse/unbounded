# encoding: utf-8

require 'spec_helper'

shared_examples_for 'an unbounded maximum' do
  it_should_behave_like 'any unbounded range'

  it_has_behavior 'humanized (n+)'

  it 'should include any positive number' do
    should include *positive_numbers
  end

  it 'should not include negative numbers' do
    should_not include *negative_numbers
  end

  describe '#last' do
    specify 'given no parameters, it should be INFINITY' do
      subject.last.should == infinity
    end

    specify 'given an integer, it returns Array.new(n, INFINITY)' do
      subject.last(10).should == Array.new(10, infinity)
    end
  end
end
