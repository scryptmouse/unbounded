# encoding: utf-8

require 'spec_helper'

shared_examples_for 'an excluded end' do
  it { should be_exclude_end }

  it { should_not include subject.end }
end
