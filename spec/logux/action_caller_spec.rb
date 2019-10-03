# frozen_string_literal: true

require 'rails_helper'

describe Logux::ActionCaller do
  let(:action_caller) { described_class.new(action: action, meta: meta) }
  let(:action) { create(:logux_actions_add) }
  let(:meta) { create(:logux_meta) }

  context 'when attributes updated' do
    context 'when insecure #update is called' do
      let(:action) { create(:logux_actions_post, type: 'post/rename') }

      it 'raises exception when #update is called inside action' do
        expect do
          action_caller.call!
        end.to raise_error(Logux::Model::InsecureUpdateError)
      end
    end

    context 'when secure #update is called' do
      let(:action) { create(:logux_actions_post, type: 'post/touch') }

      it 'raises exception when #update is called inside action' do
        expect { action_caller.call! }.not_to raise_error
      end
    end
  end
end
