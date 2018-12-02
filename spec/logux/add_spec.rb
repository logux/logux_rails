# frozen_string_literal: true

require 'spec_helper'

describe Logux::Add, timecop: true do
  let(:request) { described_class.new }

  describe '#call' do
    let(:action) { { id: 1 } }
    let(:meta) { create(:logux_meta) }
    let(:logux_commands) do
      [['action', { id: 1 }, meta], ['action', { id: 2 }, meta]]
    end

    it 'return processed' do
      expect { request.call(action, meta) }.to send_to_logux(
        ['action', { id: 1 }, a_logux_meta]
      )
    end
  end
end
