# encoding: utf-8

require 'spec_helper'

shared_examples_for 'a finite minimum' do
  describe '#first' do
    specify 'given no parameters, it returns #min' do
      subject.first.should == subject.min
    end

    specify 'given an integer, it defers to super' do
      subject.first(10).should be_a_kind_of Array
    end
  end
end
