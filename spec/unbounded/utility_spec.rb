# encoding: utf-8

require 'spec_helper'

describe Unbounded::Utility do
  let(:dummy_class) { Module.new { extend Unbounded::Utility } }

  describe '#match_to_hash' do
    let(:regex) { %r:^(?<first_word>\w+)[^\w]*(?<second_word>\w+): }
    let(:test_string) { 'Hello, world!' }
    let(:match_data) { test_string.match(regex) }

    subject { dummy_class.match_to_hash(match_data) }

    it 'converts `MatchData` to a hash' do
      subject.should be_a_kind_of Hash
    end

    it 'has the expected contents' do
      should include 'first_word' => 'Hello', 'second_word' => 'world'
    end
  end

  describe '#numerify' do
    context 'given a numeric value' do
      it 'returns the same' do
        dummy_class.numerify(1).should eq 1
        dummy_class.numerify(2.0).should eq 2.0
      end
    end

    context 'given a float-containing string' do
      it_has_behavior 'numerification', :want => 1.0, :klass => Float
    end

    context 'given an integer-containing string' do
      it_has_behavior 'numerification', :want => 1, :klass => Integer
    end

    context 'on a failed conversion' do
      context 'given no default' do
        it_has_behavior 'numerification', :provide => 'anything else'
      end

      context 'default: :original' do
        it_has_behavior 'numerification', :provide => 'some string', :default => :original
      end

      context 'default: some other string' do
        it_has_behavior 'numerification', :provide => 'some string', :default => 'some other string'
      end
    end
  end
end
