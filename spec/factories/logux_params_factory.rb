FactoryBot.define do
  factory :logux_params, class: Logux::Params do
    factory :logux_params_subscribe do
      type 'logux/subscribe'
      channel 'user/1'
    end

    factory :logux_params_add do
      type 'user/add'
      key 'name'
      value 'test'
    end

    factory :logux_params_update do
      type 'user/update'
      key 'name'
      value 'test1'
    end
  end
end
