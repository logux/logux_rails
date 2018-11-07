# frozen_string_literal: true

FactoryBot.define do
  factory :logux_actions, class: Logux::Actions do
    factory :logux_actions_subscribe do
      skip_create
      type { 'logux/subscribe' }
      channel { 'user/1' }
    end

    factory :logux_actions_add do
      skip_create
      type { 'user/add' }
      key { 'name' }
      value { 'test' }
    end

    factory :logux_actions_update do
      skip_create
      type { 'user/update' }
      key { 'name' }
      value { 'test1' }
    end

    factory :logux_actions_unknown do
      skip_create
      type { 'unknown/action' }
    end

    factory :logux_actions_unknown_subscribe do
      type { 'logux/subscribe' }
      channel { 'unknown/channel' }
    end
  end
end
