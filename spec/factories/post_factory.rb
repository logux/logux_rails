# frozen_string_literal: true

FactoryBot.define do
  factory :post, class: Post do
    title { 'initial' }
    content { 'initial' }
  end
end
