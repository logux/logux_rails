# frozen_string_literal: true

require 'spec_helper'

describe Logux::Model do
  subject(:model) do
    create(
      :post,
      logux_fields_updated_at: {
        title: initial_meta.logux_id,
        content: initial_meta.logux_id
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
    it 'updates logux.updated_at' do
      model.update_attributes(title: 'something')

      title_updated_at = model.logux.updated_at(:title)
      expect(title_updated_at).not_to eq(initial_meta.logux_id)
    end
  end

  describe '#update_attribute' do
    it 'updates logux.updated_at' do
      model.update_attribute(:content, 'something')

      content_updated_at = model.logux.updated_at(:content)
      expect(content_updated_at).not_to eq(initial_meta.logux_id)
    end
  end

  describe 'direct attribute assignment' do
    it 'updates logux.updated_at' do
      model.content = 'something'
      model.save

      content_updated_at = model.logux.updated_at(:content)
      expect(content_updated_at).not_to eq(initial_meta.logux_id)
    end
  end
end
