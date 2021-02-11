# frozen_string_literal: true

require 'rails_helper'

describe 'Request logux server' do
  subject(:request_logux) do
    post('/logux',
         params: logux_params,
         as: :json)
  end

  let(:secret) { Logux.configuration.secret }

  let(:logux_params) do
    { version: Logux::PROTOCOL_VERSION,
      secret: secret,
      commands: [
        ['action',
         { type: 'logux/subscribe', channel: 'post/123' },
         { time: Time.now.to_i, id: '219_856_768 clientid 0', userId: 1 }],
        ['action',
         { type: 'comment/add', key: 'text', value: 'hi' },
         { time: Time.now.to_i, id: '219_856_768 clientid 0', userId: 1 }]
      ] }
  end

  context 'when authorized' do
    before { request_logux }

    it 'returns approved chunk' do
      expect(response).to logux_approved('219_856_768 clientid 0')
    end

    it 'returns processed chunk' do
      expect(response).to logux_processed('219_856_768 clientid 0')
    end
  end

  context 'when no authorized' do
    before { request_logux }

    let(:logux_params) do
      { version: Logux::PROTOCOL_VERSION,
        secret: secret,
        commands: [
          ['action',
           { type: 'comment/update', key: 'text', value: 'hi' },
           { time: Time.now.to_i, id: '219_856_768 clientid 0', userId: 1 }]
        ] }
    end

    it 'returns correct body' do
      expect(response).to logux_forbidden
    end
  end

  context 'when secret wrong' do
    before { request_logux }

    let(:secret) { 'INTENTIONALLY_WRONG' }

    it 'returns error' do
      expect(response).to be_forbidden
    end
  end

  context 'with proxy' do
    let(:logux_params) do
      { version: Logux::PROTOCOL_VERSION,
        secret: secret,
        commands: [
          ['action',
           { type: 'logux/subscribe', channel: 'post/123' },
           { time: Time.now.to_i, proxy: 'proxy_id',
             id: '219_856_768 clientid 0', userId: 1 }],
          ['action',
           { type: 'comment/add', key: 'text', value: 'hi' },
           { time: Time.now.to_i, id: '219_856_768 clientid 0', userId: 1 }]
        ] }
    end

    it 'returns correct chunk' do
      expect { request_logux }.to change { logux_store.size }.by(1)
    end
  end
end
