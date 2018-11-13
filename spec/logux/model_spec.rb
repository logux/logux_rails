# frozen_string_literal: true

require 'spec_helper'

describe Logux::Model do
  subject(:model) do
    create(
      :post,
      logux_fields_updated_at: {
        title: initial_meta.comparable_time,
        content: initial_meta.comparable_time
      }
    )
  end

  let(:older_update_meta) do
    create(
      :logux_meta,
      time: Time.parse('01-11-2018 12:05').to_datetime.strftime('%Q')
    )
  end

  let(:initial_meta) do
    create(
      :logux_meta,
      time: Time.parse('01-11-2018 12:10').to_datetime.strftime('%Q')
    )
  end

  let(:newer_update_meta) do
    create(
      :logux_meta,
      time: Time.parse('01-11-2018 12:15').to_datetime.strftime('%Q')
    )
  end

  let(:latest_update_meta) do
    create(
      :logux_meta,
      time: Time.parse('01-11-2018 12:20').to_datetime.strftime('%Q')
    )
  end

  describe '#update' do
    it 'updates newer attribute' do
      model.logux.update(newer_update_meta, content: 'newer')
      expect(model.content).to eq('newer')
    end

    it 'keeps attribute updated later' do
      model.logux.update(older_update_meta, content: 'older')
      expect(model.content).to eq('initial')
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'updates multiple fields' do
      model.logux.update(latest_update_meta, content: 'latest')
      expect(model).to have_attributes(title: 'initial', content: 'latest')

      model.logux.update(newer_update_meta, title: 'newer', content: 'newer')
      expect(model).to have_attributes(title: 'newer', content: 'latest')
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe '#update_attributes' do
    it 'raises exception when user tries to update attribute directly' do
      expect do
        model.update_attributes(title: 'something', content: 'something')
      end.to raise_exception(RuntimeError)
    end

    it 'allows updating not tracked attributes' do
      expect do
        model.update_attributes(updated_at: 2.days.ago)
      end.not_to raise_exception
    end
  end

  describe '#update_attribute' do
    it 'raises exception when user tries to update attribute directly' do
      expect do
        model.update_attribute(:content, 'something')
      end.to raise_exception(RuntimeError)
    end

    it 'allows updating not tracked attributes' do
      expect do
        model.update_attribute(:updated_at, 2.days.ago)
      end.not_to raise_exception
    end
  end
end
