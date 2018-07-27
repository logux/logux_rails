# frozen_string_literal: true

require 'spec_helper'

describe Logux::Actions do
  let(:actions) { described_class.new(type: 'user/add', channel: 'project/123') }

  describe '#action_type' do
    subject { actions.action_type }

    it { should eq 'add' }
  end

  describe '#action_name' do
    subject { actions.action_name }

    it { should eq 'user' }
  end

  describe '#channel_name' do
    subject { actions.channel_name }

    it { should eq 'project' }
  end

  describe '#channel_id' do
    subject { actions.channel_id }

    it { should eq '123' }
  end
end
