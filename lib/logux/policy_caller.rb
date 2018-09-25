# frozen_string_literal: true

module Logux
  class PolicyCaller
    attr_reader :action, :meta, :policy

    def initialize(action:, meta:)
      @action = action
      @meta = meta
    end

    def call!
      Logux.logger
           .info("Searching policy for Logux action: #{action}, meta: #{meta}")
      policy_class = class_finder.find_policy_class
      if policy_class
        @policy = policy_class.new(action: action, meta: meta)
        policy.public_send("#{action.action_type}?")
      else
        class_namespace = class_finder.class_namespace.singularize
        ["unknown#{class_namespace}", meta.id]
      end
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action)
    end
  end
end
