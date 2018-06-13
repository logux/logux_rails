require 'spec_helper'

describe Logux::Client do
  let(:client) { described_class.new }
  let(:params) { create(:logux_params_add) }

  describe '#post' do
    subject { client.post(params) }

    before do
      stub_request(:post, Logux.configuration.logux_host)
        .with(body: params.to_h.to_json)
        .to_return(body: ['processed',
                          { 'id' => [219_856_768, 'clientid', 0] }].to_json)
    end

    it 'performs request' do
      expect(subject).to be_truthy
    end
  end
end
