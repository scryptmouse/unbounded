# encoding: utf-8

require 'spec_helper'

shared_examples_for 'numerification' do |opts = {}|
  if opts.key?(:want)
    let(:wanted) { opts[:want] }

    it 'converts to the expected value' do
      should == wanted
    end
  elsif opts.key?(:default)
    if opts[:default] == :original
      it 'should return the original' do
        should eq provided
      end
    else
      it 'returns the default' do
        should eq default
      end
    end
  else
    it 'returns nil' do
      should be_nil
    end
  end

  let(:provided) do
    opts.fetch(:provide) do
      opts.fetch(:want).presence.to_s
    end
  end

  let (:default) { opts[:default] }

  subject { dummy_class.numerify(provided, default) }

  if opts.key? :klass
    let(:klass) { opts[:klass] }

    it "coerces to a #{opts[:klass]}" do
      should be_a_kind_of klass
    end
  end

end
