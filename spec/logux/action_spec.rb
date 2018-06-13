require 'rails_helper'

describe Logux::Action do
  let(:action) { described_class.new(params: params, meta: meta) }
  let(:params) { {} }
  let(:meta) { {} }

  describe '#subscribe' do
    subject { action.subscribe }

    context 'when ActiveRecord undefined' do
      it 'raises error' do
        expect { subject }.to raise_error(Logux::Action::UnknownTypeError)
      end
    end
  end
end
