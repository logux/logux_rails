# frozen_string_literal: true

require 'spec_helper'

describe Logux::ChannelController do
  let(:channel_controller) { described_class.new(action: action, meta: meta) }
  let(:action) { create(:logux_actions_subscribe) }
  let(:user) { User.find_or_create_by(id: 1, name: 'test') }
  let(:meta) { Logux::Meta.new }
  let!(:logux_request) { stub_request(:post, Logux.configuration.logux_host) }

  describe '#subscribe' do
    subject { channel_controller.subscribe }

    context 'when ActiveRecord defined' do
      it 'tries to find record by chanel data' do
        subject
        expect(logux_request).to have_been_made.times(1)
      end
    end
  end
end
