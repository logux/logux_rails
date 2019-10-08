# frozen_string_literal: true

require 'spec_helper'

describe Logux::Meta do
  subject(:meta) { described_class.new(attributes) }

  let(:attributes) { {} }

  describe '#new' do
    context 'with empty meta' do
      it 'generates id' do
        expect(meta.id).not_to be nil
      end

      it 'generates time' do
        expect(meta.time).not_to be nil
      end
    end

    context 'with id' do
      let(:attributes) { { id: '112 10:uuid 0' } }

      it 'fills time' do
        expect(meta.time).to eq('112')
      end
    end

    context 'with meta' do
      let(:time) { '4321' }
      let(:id) { '1234' }
      let(:attributes) { { id: id, time: time } }

      it 'does not rewrite id if it is provided' do
        expect(meta.id).to eq(id)
      end

      it 'does not rewrite time if it is provided' do
        expect(meta.time).to eq(time)
      end
    end
  end

  describe '#logux_order' do
    let(:attributes) { { id: '100 10:uuid 0', time: '200' } }

    it 'combines id and time' do
      expect(meta.logux_order).to eq('200 10:uuid 0')
    end
  end

  describe '#user_id' do
    let(:attributes) { { id: '1 user:client:id 0' } }

    it 'parses user ID' do
      expect(meta.user_id).to eq('user')
    end
  end

  describe '#node_id' do
    let(:attributes) { { id: '1 user:client:id 0' } }

    it 'parses node ID' do
      expect(meta.node_id).to eq('user:client:id')
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

  describe '#undo_meta' do
    subject(:undo_meta) { meta.undo_meta }

    context 'with resend keys' do
      let(:attributes) do
        {
          'users' => %w[user],
          'nodes' => %w[node],
          'reasons' => %w[reason],
          'channels' => %w[channel]
        }
      end

      it 'copies re-send keys' do
        expect(undo_meta).to include(attributes)
      end
    end

    context 'with clients list' do
      let(:clients_list) { %w[client] }
      let(:attributes) { { 'clients' => clients_list } }

      it 'appends client ids' do
        expect(undo_meta['clients']).to eq([meta.client_id] + clients_list)
      end
    end

    context 'without clients list' do
      it 'contains client id' do
        expect(undo_meta['clients']).to eq([meta.client_id])
      end
    end
  end
end
