# frozen_string_literal: true

FactoryBot.define do
  factory :logux_meta, class: Logux::Meta do
    skip_create
    initialize_with do
      new(attributes)
    end
  end
end
