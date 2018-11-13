# frozen_string_literal: true

require 'logux/model/insecure_update_subscriber'

module Logux
  class ActionCaller
    attr_reader :action, :meta

    delegate :logger, to: :Logux

    def initialize(action:, meta:)
      @action = action
      @meta = meta
    end

    def call!
      detect_insecure_updates do
        logger.info(
          "Searching action for Logux action: #{action}, meta: #{meta}"
        )
        format(action_controller.public_send(action.action_type))
      end
    rescue Logux::UnknownActionError, Logux::UnknownChannelError => e
      logger.warn(e)
      format(nil)
    end

    private

    def format(response)
      return response if response.is_a?(Logux::Response)

      Logux::Response.new(:processed, action: action, meta: meta)
    end

    def class_finder
      @class_finder ||= Logux::ClassFinder.new(action: action, meta: meta)
    end

    def action_controller
      class_finder.find_action_class.new(action: action, meta: meta)
    end

    def detect_insecure_updates
      ActiveSupport::Notifications.subscribe(
        'logux.insecure_update',
        Logux::Model::InsecureUpdateSubscriber.new
      )
      yield
    ensure
      ActiveSupport::Notifications.unsubscribe('logux.insecure_update')
    end
  end
end
