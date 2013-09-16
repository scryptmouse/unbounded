# encoding: utf-8

require 'spec_helper'

shared_examples_for 'an unbounded minimum' do
  it_should_behave_like 'any unbounded range'

  it 'should include any negative number' do
    should include *negative_numbers
  end

  it 'should not include positive numbers' do
    should_not include *positive_numbers
  end

  describe '#first' do
    specify 'given no parameters, it should be -INFINITY' do
      subject.first.should == negative_infinity
    end

    specify 'given an integer, it returns Array.new(n, -INFINITY)' do
      subject.first(10).should == Array.new(10, negative_infinity)
    end
  end
end
