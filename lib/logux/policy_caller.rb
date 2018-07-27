# frozen_string_literal: true

module Logux
  class PolicyCaller
    attr_reader :actions, :meta, :policy

    def initialize(actions:, meta:)
      @actions = actions
      @meta = meta
    end

    def call!
      Logux.logger.info("Searching policy for actions: #{actions}, meta: #{meta}")
      policy_class = class_finder.find_policy_class
      @policy = policy_class.new(actions: actions, meta: meta)
      policy.public_send("#{actions.action_type}?")
    rescue Logux::NoPolicyError => e
      raise e if Logux.configuration.verify_authorized
      Logux.logger.warn(e)
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(actions)
    end
  end
end
