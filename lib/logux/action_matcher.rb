# frozen_string_literal: true

module Logux
  class ActionMatcher
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def action
      action_name = if params.type == 'logux/subscribe'
                      params.channel_name
                    else
                      params.action
                    end

      "Action::#{action_name.camelize}".constantize
    end
  end
end
