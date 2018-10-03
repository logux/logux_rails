# frozen_string_literal: true

require 'spec_helper'

describe Logux::ActionController do
  let(:action_controller) { described_class.new(action: action, meta: meta) }
  let(:action) { create(:logux_actions_subscribe) }
  let(:user) { User.find_or_create_by(id: 1, name: 'test') }
  let(:meta) { Logux::Meta.new }

  describe '#respond' do
    subject(:response) { action_controller.respond(:processed) }

    it 'returns logux response' do
      expect(response).to have_attributes(
        status: :processed, action: action, custom_data: nil
      )
    end

    it 'sets the meta with time' do
      expect(response.meta).to have_key(:time)
    end
  end

  describe '.verify_authorized!' do
    subject(:verify_authorized!) { described_class.verify_authorized! }

    around do |example|
      Logux.configuration.verify_authorized = false
      example.call
      Logux.configuration.verify_authorized = true
    end

    it 'sets to true' do
      expect { verify_authorized! }
        .to change { Logux.configuration.verify_authorized }
        .from(false)
        .to(true)
    end
  end

  describe '.unverify_authorized!' do
    subject(:unverify_authorized!) { described_class.unverify_authorized! }

    before { Logux.configuration.verify_authorized = true }

    it 'sets to false' do
      expect { unverify_authorized! }
        .to change { Logux.configuration.verify_authorized }
        .from(true)
        .to(false)
    end
  end
end
