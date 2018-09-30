# frozen_string_literal: true

module Logux
  class PolicyCaller
    attr_reader :action, :meta, :policy, :stream

    def initialize(action:, meta:, stream:)
      @action = action
      @meta = meta
      @stream = stream
    end

    def call!
      Logux.logger
           .info("Searching policy for Logux action: #{action}, meta: #{meta}")
      call_policy
    rescue Logux::NoPolicyError => e
      stream.write(unknown_events)
      raise e if Logux.configuration.verify_authorized
      Logux.logger.warn(e)
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action)
    end

    private

    def call_policy
      policy_class = class_finder.find_policy_class
      @policy = policy_class.new(action: action, meta: meta)
      policy.public_send("#{action.action_type}?")
    end

    def unknown_events
      class_namespace = class_finder.class_namespace.singularize
      ["unknown#{class_namespace}", meta.id]
    end
  end
end
