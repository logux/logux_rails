# frozen_string_literal: true

require 'spec_helper'

describe Logux::Model::UpdatesDeprecator do
  let(:post) { create(:post) }

  context 'with error level' do
    it 'raises error when insecure update is detected' do
      expect do
        described_class.call(level: :error) do
          post.update(title: 'new title')
        end
      end.to raise_error(Logux::Model::InsecureUpdateError)
    end

    it 'does not raise error when update is secure' do
      expect do
        described_class.call(level: :error) do
          post.update(updated_at: Time.now)
        end
      end.not_to raise_error
    end
  end

  context 'with warn level' do
    it 'outputs deprecation warning when update is detected' do
      expect do
        described_class.call(level: :warn) do
          post.update(title: 'new title')
        end
      end.to output(/DEPRECATION WARNING/).to_stderr
    end

    it 'uses warn level by default' do
      expect do
        described_class.call do
          post.update(title: 'new title')
        end
      end.to output(/DEPRECATION WARNING/).to_stderr
    end
  end
end
