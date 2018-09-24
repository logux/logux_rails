# frozen_string_literal: true

require 'spec_helper'

describe Logux::Node do
  let(:node) { described_class.instance }

  describe '#generate_action_id' do
    subject { node.generate_action_id }

    it 'returns correct id' do
      expect(subject).to match(/^[0-9]{13} server:.{8} 0$/)
    end

    context 'with action at the same time', timecop: true do
      before do
        node.sequence = 0
        node.last_time = nil
        node.generate_action_id
      end

      it 'returns 1 in sequence' do
        expect(subject).to match(/^[0-9]{13} server:.{8} 1$/)
      end
    end
  end

  describe '#node_id' do
    subject { node.node_id }

    it 'generates nanoid' do
      expect(subject).not_to be_empty
    end

    it "doesn't change from call to call" do
      expect(subject).to eq(node.node_id)
    end
  end
end
