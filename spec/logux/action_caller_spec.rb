# frozen_string_literal: true

require 'spec_helper'

describe Logux::ActionCaller do
  let(:action_caller) { described_class.new(action: action, meta: meta) }
  let(:action) { create(:logux_actions_add) }
  let(:meta) { create(:logux_meta) }

  describe '#call!' do
    context 'when action defined' do
      subject(:result) { action_caller.call! }

      before do
        module Actions
          class User < Logux::ActionController
            def add
              respond(:ok)
            end
          end
        end
      end

      after do
        Actions::User.send :undef_method, :add
        Actions.send :remove_const, :User
        Actions.send :const_set, :User, Class.new
      end

      it 'return ok' do
        expect(result.status).to eq(:ok)
      end
    end
  end

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
