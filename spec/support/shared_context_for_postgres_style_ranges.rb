# encoding: utf-8

require 'spec_helper'

shared_context 'postgres', pg: :true do
  subject { described_class.new example.metadata[:postgres] }

  let(:equivalent_range) { example.metadata[:equiv] }

  it '== an equivalent range' do
    should == equivalent_range
  end

  it_behaves_like 'postgres range exclusivity'
end
