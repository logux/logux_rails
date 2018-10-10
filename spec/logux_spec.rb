# frozen_string_literal: true

describe Logux, timecop: true do
  it 'has a version number' do
    expect(Logux::VERSION).not_to be nil
  end

  describe '.add' do
    before { described_class.add(type) }

    let(:type) { [] }

    it 'makes request' do
      expect(WebMock).to have_requested(:post, Logux.configuration.logux_host)
    end
  end

  describe '.generate_action_id' do
    subject(:action_id) { described_class.generate_action_id }

    it 'returns correct action id' do
      expect(action_id).not_to be_empty
    end
  end

  describe '.undo' do
    let(:request) { described_class.undo(meta: meta, reason: reason) }

    let(:meta) do
      Logux::Meta.new(
        id: '1 1:uuid 0',
        users: ['3'],
        reasons: ['user/1/lastValue'],
        nodeIds: ['2:uuid'],
        channels: ['user/1']
      )
    end

    let(:reason) { 'error' }

    let(:logux_request) do
      {
        version: 0,
        password: nil,
        commands: [
          ['action', ['type', 'logux/undo'], meta],
          ['action', ['id', meta[:id]], meta],
          ['action', ['reason', reason], meta]
        ]
      }
    end

    it 'makes request' do
      expect { request }.to send_to_logux(logux_request)
    end
  end
end
