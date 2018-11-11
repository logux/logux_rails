# frozen_string_literal: true

require 'rails_helper'

describe 'Request logux server without subscribe' do
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
         { type: 'logux/subscribe', channel: channel },
         { time: Time.now.to_i, id: '219_856_768 clientid 0', userId: 1 }]
      ] }
  end

  context 'when verify_authorized=true' do
    before { Logux.configuration.verify_authorized = true }

    context 'when policy not exists' do
      let(:channel) { 'notexists/123' }

      it 'returns unknownChannel' do
        request_logux
        expect(response.stream).to have_chunk(
          ['unknownChannel', '219_856_768 clientid 0']
        )
      end
    end

    context 'when policy is exists' do
      let(:channel) { 'policy_without_channel/123' }

      it 'returns processed' do
        request_logux
        expect(response.stream).to have_chunk(
          ['processed', '219_856_768 clientid 0']
        )
      end
    end
  end

  context 'when verify_authorized=false' do
    let(:channel) { 'notexists/123' }

    before { Logux.configuration.verify_authorized = false }

    it 'returns processed' do
      request_logux
      expect(response.stream).to have_chunk(
        ['processed', '219_856_768 clientid 0']
      )
    end
  end
end
