# frozen_string_literal: true

require 'spec_helper'

describe Logux::Client do
  let(:client) { described_class.new }
  let(:params) { create(:logux_actions_add) }

  describe '#post' do
    it 'performs request' do
      expect { client.post(params) }.to send_to_logux(params)
    end
  end
end
