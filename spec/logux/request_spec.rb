# frozen_string_literal: true

require 'spec_helper'

describe Logux::Request, timecop: true do
  let(:request) { described_class.new }

  describe '#add_action' do
    subject { request.add_action(type, params: params, meta: meta) }

    let(:type) { 'user/add' }
    let(:params) { create(:logux_params_add) }
    let(:meta) { create(:logux_meta) }

    context 'when params has no overwrited keys' do
      let(:params) { { key: 'name', value: 'test' } }
      let(:meta) { create(:logux_meta) }
      before do
        stub_request(:post, Logux.configuration.logux_host)
          .with(body: ['action', params.merge(type: type), meta.with_time!].to_json)
          .to_return(body: ['processed',
                            { 'id' => [219_856_768, 'clientid', 0] }].to_json)
      end

      it '' do
        expect(subject).to be_truthy
      end
    end
  end
end
