# frozen_string_literal: true

describe Logux, timecop: true do
  it 'has a version number' do
    expect(Logux::VERSION).not_to be nil
  end

  describe '.add' do
    subject { described_class.add(type) }

    let(:type) { [] }

    it 'makes request' do
      subject
      expect(WebMock).to have_requested(:post, Logux.configuration.logux_host)
    end
  end

  describe '.generate_action_id' do
    subject { described_class.generate_action_id }

    it 'returns correct action id' do
      expect(subject).not_to be_empty
    end
  end
end
