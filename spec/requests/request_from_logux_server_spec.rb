# frozen_string_literal: true

require 'rails_helper'

describe 'Logux response' do
  subject do
    post('/logux',
         params: logux_params,
         as: :json)
  end

  let(:logux_params) do
    [
      ['action',
       { type: 'logux/subscribe', channel: 'post/123' },
       { time: Time.now.to_i, id: [219_856_768, 'clientid', 0], userId: 1 }],
      ['action',
       { type: 'comment/add', key: 'text', value: 'hi' },
       { time: Time.now.to_i, id: [219_856_768, 'clientid', 0], userId: 1 }]
    ]
  end

  let(:logux_response) do
    [
      ['processed', {  'id' => [219_856_768, 'clientid', 0] }],
      ['processed', {  'id' => [219_856_768, 'clientid', 0] }]
    ]
  end

  let(:read_server_response) do
    "[#{response.stream.body.gsub('][', '],[')}]"
  end

  it 'does return correct body' do
    subject
    expect(response.stream).to start_from_chunk(logux_response[0])
    expect(response.stream).to end_with_chunk(logux_response[1])
  end
end
