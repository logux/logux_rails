# frozen_string_literal: true

require 'spec_helper'

describe Logux::Meta do
  subject(:meta) { described_class.new(attributes) }

  let(:attributes) { {} }

  describe '#new' do
    context 'with empty meta' do
      it 'generates id' do
        expect(meta[:id]).not_to be nil
      end

      it 'generates time' do
        expect(meta[:time]).not_to be nil
      end
    end

    context 'with meta' do
      let(:time) { '4321' }
      let(:id) { '1234' }
      let(:attributes) { { id: id, time: time } }

      it 'does not rewrite id if it is provided' do
        expect(meta[:id]).to eq(id)
      end

      it 'does not rewrite time if it is provided' do
        expect(meta[:time]).to eq(time)
      end
    end
  end

  describe '#client_id' do
    let(:attributes) { { id: id } }

    context 'with full node ID' do
      let(:id) { '1 user:client:id 0' }

      it 'parses client ID' do
        expect(meta.client_id).to eq('user:client')
      end
    end

    context 'with short node ID' do
      let(:id) { '1 id 0' }

      it 'parses client ID' do
        expect(meta.client_id).to eq('id')
      end
    end
  end
end
