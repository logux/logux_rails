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
    subject { described_class.undo(meta: meta, reason: reason) }

    let(:meta) do
      {
        id: '1 1:uuid 0',
        users: ['3'],
        reasons: ['user/1/lastValue'],
        nodeIds: ['2:uuid'],
        channels: ['user/1']
      }
    end

    let(:reason) { 'error' }

    before { stub_request(:post, Logux.configuration.logux_host) }

    it 'makes request' do
      subject
      expect(WebMock).to have_requested(:post, Logux.configuration.logux_host)
    end
  end
end
