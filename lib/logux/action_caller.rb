# frozen_string_literal: true

module Logux
  class ActionCaller
    attr_reader :action, :meta

    delegate :logger, to: :Logux

    def initialize(action:, meta:)
      @action = action
      @meta = meta
    end

    def call!
      Logux::Model::UpdatesDeprecator.watch(level: :error) do
        logger.info(
          "Searching action for Logux action: #{action}, meta: #{meta}"
        )
        action_controller.public_send(action.action_type)
      end
    rescue Logux::UnknownActionError, Logux::UnknownChannelError => e
      logger.warn(e)
    end

    private

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action: action, meta: meta)
    end

    def action_controller
      class_finder.find_action_class.new(action: action, meta: meta)
    end
  end
end
