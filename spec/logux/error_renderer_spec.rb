# frozen_string_literal: true

require 'spec_helper'

describe Logux::ErrorRenderer do
  let(:action_id) { '123 10:uuid 0' }
  let(:meta) { create(:logux_meta, id: action_id) }

  describe '#message' do
    def build_message(exception)
      described_class.new(exception).message
    end

    it 'returns correct error message for UnknownActionError' do
      exception = Logux::UnknownActionError.new('test', meta: meta)

      expect(build_message(exception)).to eq(['unknownAction', action_id])
    end

    it 'returns correct error message for UnknownChannelError' do
      exception = Logux::UnknownChannelError.new('test', meta: meta)

      expect(build_message(exception)).to eq(['unknownChannel', action_id])
    end

    it 'returns correct error message for UnauthorizedError' do
      exception = Logux::UnauthorizedError.new('test')

      expect(build_message(exception)).to eq(%w[unauthorized test])
    end

    context 'when Logux.configuration.render_backtrace_on_error is true' do
      around do |example|
        Logux.configuration.render_backtrace_on_error = true
        example.run
        Logux.configuration.render_backtrace_on_error = false
      end

      it 'returns correct error with backtrace for some unknown error' do
        exception = StandardError.new('Test')
        exception.set_backtrace(caller)

        expect(build_message(exception)).to eq(
          ['error', "Test\n" + exception.backtrace.join("\n")]
        )
      end
    end

    context 'when Logux.configuration.render_backtrace_on_error is false' do
      it 'returns correct error message for some unknown error' do
        exception = StandardError.new

        expect(build_message(exception)).to eq(
          ['error', 'Please look server logs for more information']
        )
      end
    end
  end
end
