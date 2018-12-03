# frozen_string_literal: true

require 'spec_helper'

describe Logux::ChannelController do
  let(:controller_class) do
    FakeController = Class.new(described_class) do
      def initial_data
        [{ type: 'action' }]
      end
    end
  end
  let(:channel_controller) { controller_class.new(action: action, meta: meta) }
  let(:action) { create(:logux_actions_subscribe) }
  let(:user) { User.find_or_create_by(id: 1, name: 'test') }
  let(:meta) { Logux::Meta.new }

  describe '#subscribe' do
    subject(:subscribe) { channel_controller.subscribe }

    context 'when ActiveRecord defined' do
      it 'tries to find record by chanel data' do
        expect { subscribe }.to send_to_logux(['action', { type: 'action' }])
      end
    end
  end
end
