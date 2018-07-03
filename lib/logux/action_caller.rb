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
      format(action.public_send(params.action_type))
    rescue Logux::Policy::UnauthorizedError
      format(action.respond(:forbidden))
    end

    private

    def format(response)
      return response if response.is_a? Logux::Response
      Logux::Response
        .new(:processed, params: params, meta: meta)
    end

    def action_class_for(params)
      find_class_for(params)
    rescue NameError
      raise Logux::NoActionError, %(
        Unable to find action #{action_name(params).camelize}
        Should be in app/logux/actions/#{action_name(params)}.rb
      )
    end

    def policy_class_for(params)
      find_class_for(params, type: 'policies')
    rescue NameError
      raise Logux::NoPolicyError, %(
        Unable to find policy #{action_name(params).camelize}
        Should be in app/logux/policies/#{action_name(params)}.rb
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
