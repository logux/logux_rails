# frozen_string_literal: true

module Logux
  class ActionCaller
    attr_reader :params, :meta, :action

    def initialize(params:, meta:)
      @params = params
      @meta = meta
    end

    def call!
      action_class = find_class_for(params)
      @action = action_class.new(params: params, meta: meta)
      authorize! if authorizable?
      action.public_send(params.action_type).format
    rescue Logux::Policy::UnauthorizedError
      action.respond(:forbidden)
    rescue StandardError
      action.respond(:internal_error)
    end

    private

    def find_class_for(params, type: 'actions')
      action_name = if params.type == 'logux/subscribe'
                      params.channel_name
                    else
                      params.action_name
                    end

      "#{type.camelize}::#{action_name.camelize}".constantize
    end

    def authorizable?
      Logux.configuration.verify_authorized
    end

    def authorize!
      klass = find_class_for(params, type: 'policies')
      auth_object = klass.new(params: params, meta: meta, action: action)
      authorized = auth_object.public_send("#{params.action_type}?")
      raise Logux::Policy::UnauthorizedError unless authorized
    end
  end
end
