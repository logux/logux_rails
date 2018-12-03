# frozen_string_literal: true

module Logux
  class BaseController
    class << self
      def verify_authorized!
        Logux.configuration.verify_authorized = true
      end

      def unverify_authorized!
        Logux.configuration.verify_authorized = false
      end
    end

    attr_reader :action, :meta

    def initialize(action:, meta: {})
      @action = action
      @meta = meta
    end

    def respond(status, action: @action, meta: @meta, custom_data: nil)
      Logux::Response.new(status,
                          action: action,
                          meta: meta,
                          custom_data: custom_data)
    end

    def user_id
      @user_id ||= meta.user_id
    end

    def node_id
      @node_id ||= meta.node_id
    end
  end
end
