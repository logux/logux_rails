# frozen_string_literal: true

require 'rails_helper'

describe 'Logux response' do
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
  let(:params) { Logux.configuration.password }

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

  # rubocop: disable RSpec/NestedGroups
  # TODO: refactoring; may be move this cases to separated file
  context 'with unknown action' do
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
          expect(response.stream).to have_chunk(
            ['processed', '219_856_768 clientid 0']
          )
        end
      end
    end

    context 'when verify_authorized=false' do
      let(:action) { 'notexists/create' }

      before { Logux.configuration.verify_authorized = false }

      it 'returns processed' do
        request_logux
        expect(response.stream).to have_chunk(
          ['processed', '219_856_768 clientid 0']
        )
      end
    end
  end

  context 'with unknown subscribe' do
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
  # rubocop: enable RSpec/NestedGroups
end
