# encoding: utf-8

require 'spec_helper'

shared_examples_for 'postgres range exclusivity' do |*args|
  exclusivity = args.shift || {}

  exclusivity = OpenStruct.new exclusivity

  exclusivity.max = metadata.fetch(:postgres, '').end_with?(')') if exclusivity.min.nil?

  exclusivity.min = metadata.fetch(:postgres, '').start_with?('(') if exclusivity.min.nil?

  let!(:provided_range_start) { ( example.metadata.fetch(:postgres, '')[/^.(\d)+,/, 1] || 0).to_i }

  let!(:expected_range_start) { provided_range_start + (exclusivity.min ? 1 : 0) }

  if exclusivity.min
    specify 'it should have a different start than provided' do
      subject.min.should_not == provided_range_start
      subject.min.should == expected_range_start
    end

    specify 'it should not include the provided minimum' do
      subject.should_not include provided_range_start
    end
  else

    specify 'it should have the provided minimum' do
      subject.min.should == provided_range_start
    end
  
  end

  if exclusivity.max
    specify 'the end is excluded' do
      subject.should_not include subject.end
    end
  else
    specify 'the end is included' do
      subject.should include subject.max
    end
  end

  its(:exclude_end?) { should exclusivity.max ? be_true : be_false }
end
