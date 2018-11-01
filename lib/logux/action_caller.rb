# frozen_string_literal: true

module Logux
  class ActionCaller
    attr_reader :action, :meta, :action_controller

    def initialize(action:, meta:)
      @action = action
      @meta = meta
    end

    def call!
      Logux.logger
           .info("Searching action for Logux action: #{action}, meta: #{meta}")
      action_class = class_finder.find_action_class
      @action_controller = action_class.new(action: action, meta: meta)
      format(action_controller.public_send(action.action_type))
    rescue Logux::UnknownActionError, Logux::UnknownChannelError => e
      Logux.logger.warn(e)
      format(nil)
    end

    private

    def format(response)
      return response if response.is_a? Logux::Response
      Logux::Response
        .new(:processed, action: action, meta: meta)
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action: action, meta: meta)
    end
  end
end
