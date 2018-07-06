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
      channel_class = subscribe_class || params.channel_name.camelcase.constantize
      if !defined?(ActiveRecord) || channel_class.is_a?(ActiveRecord::Base)
        raise_unknown_type_error!
      end
      channel_class.find_by(id: subscribe_id || params.channel_id)
    rescue NameError
      raise_unknown_type_error!
    end

    def respond(status, params: @params, meta: @meta, custom_data: nil)
      Logux::Response.new(status,
                          params: params,
                          meta: meta,
                          custom_data: custom_data)
    end

    def request(data, params: @params, meta: @meta, custom_data: nil, version: 0)
      Logux::Request
        .new(version: version)
        .call(data,
              params: params,
              meta: meta,
              custom_data: custom_data)
    end

    def subscribe_class; end

    def subscribe_id; end

    private

    def raise_unknown_type_error!
      raise Logux::Action::UnknownTypeError
    end
  end
end
