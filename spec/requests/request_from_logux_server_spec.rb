# frozen_string_literal: true

require 'rails_helper'

describe 'Logux response', timecop: true do
  subject(:request_logux) do
    receive_action(data: logux_params, meta: logux_meta, password: password)
  end

  let(:logux_params) do
    [{ type: 'logux/subscribe', channel: 'post/123' },
     { type: 'comment/add', key: 'text', value: 'hi' }]
  end
  let(:logux_meta) { {} }

  let(:password) { Logux.configuration.password }

  context 'when authorized' do
    before { request_logux }

    it 'correct size of responses' do
      expect(request_logux.size).to eq(4)
    end

    it 'returns approved chunk' do
      expect(request_logux).to be_approved
    end

    it 'returns processed chunk' do
      expect(request_logux).to be_processed
    end
  end

  context 'when no authorized' do
    let(:logux_params) do
      { type: 'comment/update', key: 'text', value: 'hi' }
    end

    it 'does return correct body' do
      expect(request_logux).to be_forbidden
    end
  end

  context 'when password wrong' do
    let(:password) { '12345' }

    it 'does return error' do
      expect(request_logux).to be_errored
    end
  end

  context 'with proxy' do
    let(:logux_meta) do
      { proxy: 'proxy_id' }
    end

    it 'returns correct chunk' do
      expect { request_logux }.to change { logux_store.size }.by(1)
    end
  end
end
