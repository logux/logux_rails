# frozen_string_literal: true

module Logux
  class PolicyCaller
    attr_reader :params, :meta, :policy

    def initialize(params:, meta:)
      @params = params
      @meta = meta
    end

    def call!
      Logux.logger.info("Searching policy for params: #{params}, meta: #{meta}")
      policy_class = class_finder.find_policy_class
      @policy = policy_class.new(params: params, meta: meta)
      policy.public_send("#{params.action_type}?")
    end

    def find_class_for(params, type: 'actions')
      "#{type.camelize}::#{action_name(params).camelize}".constantize
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(params)
    end

    def action_name
      @action_name ||= class_finder.action_name
    end
  end
end
