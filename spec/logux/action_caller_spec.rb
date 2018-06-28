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
          class User < Logux::Action
            def add
              respond(:ok)
            end
          end
        end
      end

      it 'return ok' do
        expect(subject).to contain_exactly(:ok, {})
      end

      context 'when verify_authorized' do
        before do
          Logux.configuration.verify_authorized = true
        end

        it 'raise error' do
          expect { subject }.to raise_error(Logux::NoPolicyError)
        end

        context 'when policy defined' do
          before do
            module Policies
              class User < Logux::Policy
                def add?
                  true
                end
              end
            end
          end

          it 'return ok' do
            expect(subject).to contain_exactly(:ok, {})
          end
        end
      end
    end
  end
end
