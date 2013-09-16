# encoding: utf-8

require 'spec_helper'

shared_examples_for 'humanized string' do
  describe '#humanized' do
    it 'humanizes correctly' do
      subject.humanized.should match expected_format
    end
  end
end

shared_examples_for 'humanized (n or fewer)' do
  let(:expected_format) { %r,\d+ or fewer, }
  include_examples 'humanized string'
end

shared_examples_for "humanized (hyphenated)" do
  let(:expected_format) { %r,\d+ #{"\u2013"} \d+, }
  include_examples 'humanized string'
end

shared_examples_for 'humanized (fewer than n)' do
  let(:expected_format) { %r,fewer than \d+, }
  include_examples 'humanized string'
end

shared_examples_for 'humanized (infinite)' do
  let(:expected_format) { %r,infinite, }
  include_examples 'humanized string'
end

shared_examples_for 'humanized (n+)' do
  let(:expected_format) { %r,\d+\+, }
  include_examples 'humanized string'
end
