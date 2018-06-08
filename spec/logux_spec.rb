# frozen_string_literal: true

RSpec.describe Logux do
  it 'has a version number' do
    expect(Logux::VERSION).not_to be nil
  end

  describe '.add_action' do
    subject do
      Logux.add_action(type, params: params, meta: meta)
    end

    let(:type) { 'comment/add' }
    let(:params) { { key: 'body', value: 'Test text' } }
    let(:meta) { {} }

    around do |example|
      Timecop.freeze(Time.now)
      example.call
      Timecop.return
    end

    before do
      stub_request(:post, Logux.configuration.logux_host)
        .with(body: ['action',
                     { key: 'body', value: 'Test text', type: 'comment/add' },
                     { time: Time.now.to_i }].to_json)
        .to_return(body: ['processed', { 'id' => [219_856_768, 'clientid', 0] }].to_json)
    end

    it 'does return correct body' do
      expect(subject).to be_truthy
    end
  end
end
