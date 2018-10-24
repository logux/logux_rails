# frozen_string_literal: true

FactoryBot.define do
  factory :logux_actions, class: Logux::Actions do
    factory :logux_actions_subscribe do
      type { 'logux/subscribe' }
      channel { 'user/1' }
    end

    factory :logux_actions_add do
      type { 'user/add' }
      key { 'name' }
      value { 'test' }
    end

    factory :logux_actions_update do
      type { 'user/update' }
      key { 'name' }
      value { 'test1' }
    end
  end
end
