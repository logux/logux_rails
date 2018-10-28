# frozen_string_literal: true

FactoryBot.define do
  factory :logux_actions, class: Logux::Actions do
    factory :logux_actions_subscribe do
      skip_create
      initialize_with do
        new({ type: 'logux/subscribe', channel: 'user/1' }.merge(attributes))
      end
    end

    factory :logux_actions_add do
      skip_create
      initialize_with do
        new({ type: 'user/add', key: 'name', value: 'test' }.merge(attributes))
      end
    end

    factory :logux_actions_update do
      skip_create
      initialize_with do
        new({ type: 'user/add', key: 'name', value: 'test' }.merge(attributes))
      end
    end

    factory :logux_actions_unknown do
      skip_create
      initialize_with do
        new({ type: 'unknown/action' }.merge(attributes))
      end
    end

    factory :logux_actions_unknown_subscribe do
      skip_create
      initialize_with do
        new(
          { type: 'logux/subscribe', channel: 'unknown/channel' }
            .merge(attributes)
        )
      end
    end
  end
end
