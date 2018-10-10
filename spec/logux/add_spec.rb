# frozen_string_literal: true

require 'spec_helper'

describe Logux::Add, timecop: true do
  let(:request) { described_class.new }

  describe '#call' do
    let(:data) { [{ id: 1 }, { id: 2 }] }
    let(:meta) { create(:logux_meta) }
    let(:logux_request) do
      [{ id: 1 },
       { id: 2 }]
    end

    it 'return processed' do
      expect { request.call(data, meta: meta) }
        .to send_action_to_logux(logux_request)
    end
  end
end
