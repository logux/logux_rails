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
      @policy = policy_class.new(action: action, meta: meta)
      policy.public_send("#{action.action_type}?")
    rescue Logux::UnknownActionError, Logux::UnknownChannelError => e
      raise e if Logux.configuration.verify_authorized
      Logux.logger.warn(e)
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action: action, meta: meta)
    end
  end
end
