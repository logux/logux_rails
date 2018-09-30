# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

describe Logux::PolicyCaller do
  let(:response_stream) do
    ActionController::Live::Buffer.new(ActionDispatch::Response.new)
  end

  let(:policy_caller) do
    described_class.new(action: action, meta: meta, stream: stream)
  end

  describe '.call!' do
    subject { policy_caller.call! }

    let(:stream) { Logux::Stream.new(response_stream) }
    let(:action) { Logux::Actions.new(type: 'test/test') }
    let(:meta) { create(:logux_meta) }

    before do
      expect(stream).to receive(:write).with(['unknownAction', meta.id])
    end

    it 'doesn\'t raise an error' do
      expect(Logux.logger).to receive(:warn).once
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
