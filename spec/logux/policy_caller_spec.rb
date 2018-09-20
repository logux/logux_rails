# frozen_string_literal: true

require 'spec_helper'

describe Logux::PolicyCaller do
  let(:policy_caller) { described_class.new(action: action, meta: meta) }

  describe '.call!' do
    subject { policy_caller.call! }

    let(:action) { Logux::Actions.new(type: 'test/test') }
    let(:meta) { {} }

    it 'doesn\'t raise an error' do
      expect(Logux::Logger).to receive(:warn).once
      subject
    end

    context 'when verify_authorized' do
      around do |example|
        Logux.configuration.verify_authorized = true
        example.call
        Logux.configuration.verify_authorized = true
      end

      it 'raises an error' do
        expect { subject }.to raise_error(Logux::NoPolicyError)
      end
    end
  end
end
