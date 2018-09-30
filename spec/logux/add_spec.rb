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

    it 'return processed' do
      expect { subject }.to send_to_logux(logux_request)
    end
  end
end
