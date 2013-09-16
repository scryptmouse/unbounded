# encoding: utf-8

require 'spec_helper'

shared_examples_for 'a finite maximum' do
  describe '#last' do
    specify 'given no parameters, it returns max' do
      subject.last.should eq subject.max
    end

    specify 'given an integer, it defers to super' do
      subject.last(10).should be_a_kind_of Array
    end
  end
end
