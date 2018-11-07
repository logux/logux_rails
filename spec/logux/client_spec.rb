# frozen_string_literal: true

require 'spec_helper'

describe Logux::Client do
  let(:client) { described_class.new }
  let(:meta) { create(:logux_meta) }
  let(:commands) { [['action', { id: 1 }, meta], ['action', { id: 2 }, meta]] }
  let(:params) do
    {
      version: 0,
      password: nil,
      commands: commands
    }
  end

  describe '#post' do
    it 'performs request' do
      expect { client.post(params) }.to send_to_logux(*commands)
    end
  end
end
