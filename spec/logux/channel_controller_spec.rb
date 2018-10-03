# frozen_string_literal: true

require 'spec_helper'

describe Logux::ChannelController do
  let(:channel_controller) { described_class.new(action: action, meta: meta) }
  let(:action) { create(:logux_actions_subscribe) }
  let(:user) { User.find_or_create_by(id: 1, name: 'test') }
  let(:meta) { Logux::Meta.new }

  describe '#subscribe' do
    let(:subscribe) { channel_controller.subscribe }

    context 'when ActiveRecord defined' do
      it 'tries to find record by chanel data' do
        expect { subscribe }.to send_to_logux
      end
    end
  end
end
