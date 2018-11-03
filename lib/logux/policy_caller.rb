# frozen_string_literal: true

module Logux
  class PolicyCaller
    attr_reader :action, :meta

    delegate :logger, :configuration, to: :Logux

    def initialize(action:, meta:)
      @action = action
      @meta = meta
    end

    def call!
      logger.info("Searching policy for Logux action: #{action}, meta: #{meta}")
      policy.public_send("#{action.action_type}?")
    rescue Logux::UnknownActionError, Logux::UnknownChannelError => e
      raise e if configuration.verify_authorized

      logger.warn(e)
    end

    private

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action: action, meta: meta)
    end

    def policy
      class_finder.find_policy_class.new(action: action, meta: meta)
    end
  end
end
