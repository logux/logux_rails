# frozen_string_literal: true

module Logux
  class Action
    class UnknownTypeError < StandardError; end

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

    def subscribe
      request(subscribe_data, meta: subscribe_meta)
    end

    def respond(status, params: @params, meta: @meta, custom_data: nil)
      Logux::Response.new(status,
                          params: params,
                          meta: meta,
                          custom_data: custom_data)
    end

    def request(data, meta: @meta, version: 0)
      Logux::Request
        .new(version: version)
        .call(data,
              meta: meta)
    end

    def node_id
      meta&.dig(:id)&.split(' ')&.second
    end

    def subscribe_data
      []
    end

    def subscribe_meta
      { nodeIds: [node_id] }
    end

    private

    def raise_unknown_type_error!
      raise Logux::Action::UnknownTypeError
    end
  end
end
