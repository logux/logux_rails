# frozen_string_literal: true

require 'rails_helper'

describe 'Request logux server without action' do
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
         { type: action, key: 'text', value: 'hi' },
         { time: Time.now.to_i, id: '219_856_768 clientid 0', userId: 1 }]
      ] }
  end

  context 'when verify_authorized=true' do
    before { Logux.configuration.verify_authorized = true }

    context 'when policy not exists' do
      let(:action) { 'notexists/create' }

      it 'returns unknownAction' do
        request_logux
        expect(response.stream).to have_chunk(
          ['unknownAction', '219_856_768 clientid 0']
        )
      end
    end

    context 'when policy is exists' do
      let(:action) { 'policy_without_action/create' }

      it 'returns processed' do
        request_logux
        expect(response).to be_processed('219_856_768 clientid 0')
      end
    end
  end

  context 'when verify_authorized=false' do
    let(:action) { 'notexists/create' }

    before { Logux.configuration.verify_authorized = false }

    it 'returns processed' do
      request_logux
      expect(response).to be_processed('219_856_768 clientid 0')
    end
  end
end
