# frozen_string_literal: true

require 'rails_helper'

describe 'Logux response' do
  subject do
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
         { time: Time.now.to_i, id: [219_856_768, 'clientid', 0], userId: 1 }],
        ['action',
         { type: 'comment/add', key: 'text', value: 'hi' },
         { time: Time.now.to_i, id: [219_856_768, 'clientid', 0], userId: 1 }]
      ] }
  end
  let(:params) { Logux.configuration.password }
  let(:logux_response) do
    [
      ['processed', {  'id' => [219_856_768, 'clientid', 0] }],
      ['processed', {  'id' => [219_856_768, 'clientid', 0] }]
    ]
  end

  it 'does return correct body' do
    subject
    expect(response.stream).to have_chunk(['approved', [219_856_768, 'clientid', 0]])
    expect(response.stream).to have_chunk(logux_response[0])
    expect(response.stream).to have_chunk(logux_response[1])
  end

  context 'when no authorized' do
    let(:logux_params) do
      { version: 0,
        password: password,
        commands: [
          ['action',
           { type: 'comment/update', key: 'text', value: 'hi' },
           { time: Time.now.to_i, id: [219_856_768, 'clientid', 0], userId: 1 }]
        ] }
    end
    let(:logux_response) do
      ['forbidden', [219_856_768, 'clientid', 0]]
    end

    it 'does return correct body' do
      subject
      expect(response.stream).to have_chunk(logux_response)
    end
  end

  context 'when password wrong' do
    let(:password) { '12345' }

    it 'does return error' do
      subject
      expect(response.stream).to start_from_chunk([:error])
    end
  end
end
