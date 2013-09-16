# encoding: utf-8

require 'spec_helper'

describe Unbounded::RangeExtension do
  let(:standard_range) { 1..10 }

  subject { standard_range }

  it_has_behavior 'humanized (hyphenated)'

  describe '#unbounded' do
    its(:unbounded) { should be_a_kind_of Unbounded::Range }
    its(:unbounded) { should == standard_range }
  end
end
