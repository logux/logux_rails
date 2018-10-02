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
    let(:action_id) { described_class.generate_action_id }

    it 'returns correct action id' do
      expect(action_id).not_to be_empty
    end
  end
end
