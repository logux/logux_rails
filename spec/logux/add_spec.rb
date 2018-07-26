# frozen_string_literal: true

require 'spec_helper'

describe Logux::Add, timecop: true do
  let(:request) { described_class.new }

  describe '#call' do
    subject { request.call(data, meta: meta) }

    let(:data) { [{ id: 1 }, { id: 2 }] }
    let(:meta) { create(:logux_meta) }
    let(:logux_request) do
      {
        version: 0,
        password: nil,
        commands: [['action', { id: 1 }, meta], ['action', { id: 2 }, meta]]
      }
    end

    before do
      stub_request(:post, Logux.configuration.logux_host)
        .with(body: logux_request.to_json)
        .to_return(body: ['processed',
                          { 'id' => [219_856_768, 'clientid', 0] }].to_json)
    end

    it 'return processed' do
      expect(JSON.parse(subject)[0]).to eq('processed')
    end
  end
end
