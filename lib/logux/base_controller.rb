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

    attr_reader :params, :meta

    def initialize(params:, meta: {})
      @params = params
      @meta = meta
    end

    def respond(status, params: @params, meta: @meta, custom_data: nil)
      Logux::Response.new(status,
                          params: params,
                          meta: meta,
                          custom_data: custom_data)
    end

    def add(data, meta: @meta, version: 0)
      Logux::Add
        .new(version: version)
        .call(data,
              meta: meta)
    end

    def user_id
      @user_id ||= meta&.id&.split(' ')&.second&.split(':')&.first
    end

    def node_id
      @node_id ||= meta&.id&.split(' ')&.second
    end
  end
end
