# frozen_string_literal: true

require 'spec_helper'

describe Logux::ActionCaller do
  let(:action_caller) { described_class.new(params: params, meta: meta) }
  let(:params) { create(:logux_params_add) }
  let(:meta) { create(:logux_meta) }

  describe '#call!' do
    subject { action_caller.call! }

    it 'raise error' do
      expect { subject }.to raise_error(Logux::NoActionError)
    end

    context 'when action defined' do
      before do
        module Actions
          class User < Logux::ActionController
            def add
              respond(:ok)
            end
          end
        end
      end

      it 'return ok' do
        expect(subject.status).to eq(:ok)
      end
    end
  end
end
