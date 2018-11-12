# frozen_string_literal: true

require 'rails_helper'

describe 'Request logux server' do
  subject(:request_logux) do
    post('/logux',
         params: logux_params,
         as: :json)
  end

  let(:password) { Logux.configuration.password }

  let(:logux_params) do
    { version: 0,
      password: password,
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
      expect(response).to be_approved('219_856_768 clientid 0')
    end

    it 'returns processed chunk' do
      expect(response.stream).to have_chunk(
        ['processed', '219_856_768 clientid 0']
      )
    end
  end

  context 'when no authorized' do
    before { request_logux }

    let(:logux_params) do
      { version: 0,
        password: password,
        commands: [
          ['action',
           { type: 'comment/update', key: 'text', value: 'hi' },
           { time: Time.now.to_i, id: '219_856_768 clientid 0', userId: 1 }]
        ] }
    end
    let(:logux_response) do
      ['forbidden', '219_856_768 clientid 0']
    end

    it 'returns correct body' do
      expect(response.stream).to have_chunk(logux_response)
    end
  end

  context 'when password wrong' do
    before { request_logux }

    let(:password) { '12345' }

    it 'returns error' do
      expect(response.stream).to start_from_chunk(
        ['unauthorized', 'Incorrect password']
      )
    end
  end

  context 'with proxy' do
    let(:logux_params) do
      { version: 0,
        password: password,
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
