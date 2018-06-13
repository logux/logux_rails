# frozen_string_literal: true

require 'spec_helper'

describe Logux::Action do
  let(:action) { described_class.new(params: params, meta: meta) }
  let(:params) { Logux::Params.new(type: 'logux/subscribe', channel: 'user/1') }
  let(:user) { User.find_or_create_by(id: 1, name: 'test') }
  let(:meta) { {} }

  describe '#subscribe' do
    subject { action.subscribe }

    context 'when ActiveRecord defined' do
      it 'tries to find record by chanel data' do
        expect(subject).to eq(user)
      end
    end
  end
end
