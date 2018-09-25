# frozen_string_literal: true

require 'spec_helper'

describe Logux::PolicyCaller do
  let(:policy_caller) { described_class.new(action: action, meta: meta) }

  describe '.call!' do
    subject { policy_caller.call! }

    let(:action) { Logux::Actions.new(type: 'test/test') }
    let(:meta) { create(:logux_meta) }

    it 'doesn\'t raise an error' do
      expect(Logux.logger).to receive(:warn).once
      subject
    end

    context 'when unknown action' do
      before do
        expect(Logux.logger).to receive(:warn).once
      end

      it { expect(subject).to eq(['unknownAction', meta.id]) }
    end

    context 'when unknown channel' do
      let(:action) do
        Logux::Actions.new(type: 'logux/subscribe',
                           channel: 'test/user')
      end

      before do
        expect(Logux.logger).to receive(:warn).once
      end

      it { expect(subject).to eq(['unknownChannel', meta.id]) }
    end
  end
end
