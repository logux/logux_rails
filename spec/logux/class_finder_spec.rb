# frozen_string_literal: true

require 'spec_helper'

describe Logux::ClassFinder do
  let(:finder) { described_class.new(params) }

  describe '#class_name' do
    subject { finder.class_name }

    let(:params) { create(:logux_params_add, type: 'test/test/name/try/user/add') }

    it 'returns nested classes' do
      expect(subject).to eq('Test::Test::Name::Try::User')
    end
  end
end
