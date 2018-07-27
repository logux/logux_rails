# frozen_string_literal: true

module Logux
  class ActionCaller
    attr_reader :params, :meta, :action

    def initialize(params:, meta:)
      @params = params
      @meta = meta
    end

    def call!
      Logux.logger.info("Searching action for params: #{params}, meta: #{meta}")
      action_class = class_finder.find_action_class
      @action = action_class.new(params: params, meta: meta)
      format(action.public_send(params.action_type))
    end

    private

    def format(response)
      return response if response.is_a? Logux::Response
      Logux::Response
        .new(:processed, params: params, meta: meta)
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(params)
    end
  end
end
