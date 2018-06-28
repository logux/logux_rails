# frozen_string_literal: true

module Logux
  class ActionCaller
    attr_reader :params, :meta, :action

    def initialize(params:, meta:)
      @params = params
      @meta = meta
    end

    def call!
      action_class = action_class_for(params)
      @action = action_class.new(params: params, meta: meta)
      authorize! if authorizable?
      action.public_send(params.action_type).format
    rescue Logux::Policy::UnauthorizedError
      action.respond(:forbidden)
    end

    private

    def action_class_for(params)
      find_class_for(params)
    rescue NameError
      raise Logux::NoActionError, %(
        Unable to find action for #{action_name(params)}
      )
    end

    def policy_class_for(params)
      find_class_for(params, type: 'policies')
    rescue NameError
      raise Logux::NoPolicyError, %(
        Unable to find policy for #{action_name(params)}
      )
    end

    def find_class_for(params, type: 'actions')
      "#{type.camelize}::#{action_name(params).camelize}".constantize
    end

    def action_name(params)
      if params.type == 'logux/subscribe'
        params.channel_name
      else
        params.action_name
      end
    end

    def authorizable?
      Logux.configuration.verify_authorized
    end

    def authorize!
      auth_object = policy_class_for(params)
        .new(params: params, meta: meta, action: action)
      authorized = auth_object.public_send("#{params.action_type}?")
      raise Logux::Policy::UnauthorizedError unless authorized
    end
  end
end
