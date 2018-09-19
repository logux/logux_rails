# frozen_string_literal: true

require 'spec_helper'

describe Logux::ErrorRenderer do
  let(:meta) { create(:logux_meta, id: 123) }

  describe '#message' do
    def build_message(exception)
      described_class.new(exception).message
    end

    it 'returns correct error message for UnknownActionError' do
      exception = Logux::UnknownActionError.new('test', meta: meta)

      expect(build_message(exception)).to eq(['unknownAction', 123])
    end

    it 'returns correct error message for UnknownChannelError' do
      exception = Logux::UnknownChannelError.new('test', meta: meta)

      expect(build_message(exception)).to eq(['unknownChannel', 123])
    end

    it 'returns correct error message for UnauthorizedError' do
      exception = Logux::UnauthorizedError.new('test')

      expect(build_message(exception)).to eq(%w[unauthorized test])
    end

    it 'returns correct error message for some unknown error' do
      exception = StandardError.new

      expect(build_message(exception)).to eq(
        ['error', 'Please look server logs for more information']
      )
    end
  end
end
