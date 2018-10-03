# frozen_string_literal: true

require 'spec_helper'

describe Logux::Meta do
  let(:meta) { {} }
  subject { described_class.new(meta) }

  describe '#new' do
    context 'with empty meta' do
      it 'generates id' do
        expect(subject[:id]).to be
      end

      it 'generates time' do
        expect(subject[:time]).to be
      end
    end

    context 'with meta' do
      let(:time) { '4321' }
      let(:id) { '1234' }
      let(:meta) { { id: id, time: time } }

      it 'does not rewrite id if it is provided' do
        expect(subject[:id]).to eq(id)
      end

      it 'does not rewrite time if it is provided' do
        expect(subject[:time]).to eq(time)
      end
    end
  end
end
