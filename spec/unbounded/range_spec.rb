# encoding: utf-8

require 'spec_helper'

describe Unbounded::Range do
  let(:negative_infinity) { Unbounded::NINFINITY }
  let(:infinity)          { Unbounded::INFINITY }
  let(:positive_numbers)  { [42, 2**64] }
  let(:negative_numbers)  { [-2**64, -42] }

  describe '#unbounded' do
    specify 'returns self' do
      subject.unbounded.should be subject
    end
  end

  describe '.humanized' do
    specify { described_class.humanized(0, 10).should be_a_kind_of String }
  end

  describe '.new' do
    context 'given ()' do
      it_should_behave_like 'an infinite range'
    end

    context 'given (nil, nil)' do
      subject { described_class.new nil, nil }

      it_should_behave_like 'an infinite range'
    end

    context 'given (0, nil)' do
      subject { described_class.new 0, nil }

      it_should_behave_like 'a finite minimum'

      it_should_behave_like 'an unbounded maximum'

      it_has_behavior 'humanized (n+)'
    end

    context 'given (0, nil, true)' do
      subject { described_class.new 0, nil, true }
      
      it_should_behave_like 'an excluded end'

      it_should_behave_like 'a finite minimum'

      it_should_behave_like 'an unbounded maximum'

      it_has_behavior 'humanized (n+)'

      describe '#minmax' do
        specify 'the last element is infinity' do
          subject.minmax.last == infinity
        end
      end
    end

    context 'given (nil, 0)' do
      subject { described_class.new nil, 0 }

      it_should_behave_like 'an unbounded minimum'

      it_should_behave_like 'a finite maximum'
      
      it_has_behavior 'humanized (n or fewer)'
    end

    context 'given (nil, 0, true)' do
      subject { described_class.new nil, 0, true }

      it_should_behave_like 'an excluded end'

      it_should_behave_like 'an unbounded minimum'

      it_should_behave_like 'a finite maximum'

      it_has_behavior 'humanized (fewer than n)'
    end

    context 'with a postgres-style string argument' do
      context '()', :pg,
        :start_excluded,
        :end_excluded,
        postgres: '(1,10)',
        equiv: 2...10

      context '[)', :pg,
        :end_excluded,
        start_excluded: false,
        postgres: '[1,10)',
        equiv: 1...10

      context '(]', :pg,
        :start_excluded,
        end_excluded: false,
        postgres: '(1,10]',
        equiv: 2..10

      context '[]', :pg,
        end_excluded: false,
        start_excluded: false,
        postgres: '[1,10]',
        equiv: 1..10
    end

    context 'with a simple-style string argument' do
      context 'given 0...Infinity' do
        subject { described_class.new('0...Infinity') }

        it_should_behave_like 'a finite minimum'
        it_should_behave_like 'an unbounded maximum'
        it_should_behave_like 'an excluded end'
      end

      context 'given 1..10' do
        subject { described_class.new('1..10') }

        it_should_behave_like 'a finite minimum'
        it_should_behave_like 'a finite maximum'

        it_has_behavior 'humanized (hyphenated)'
      end
    end
  end
end
