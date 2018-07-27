# frozen_string_literal: true

describe Logux, timecop: true do
  it 'has a version number' do
    expect(Logux::VERSION).not_to be nil
  end

  describe '#add' do
    subject { described_class.add(type) }

    let(:type) { [] }

    before { stub_request(:post, Logux.configuration.logux_host) }

    it 'makes request' do
      subject
      expect(WebMock).to have_requested(:post, Logux.configuration.logux_host)
    end
  end
end
