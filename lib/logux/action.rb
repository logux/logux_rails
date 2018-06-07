# frozen_string_literal: true

module Logux
  class Action
    class EmptyType < StandardError; end
    class UnknownType < StandardError; end

    attr_reader :params, :meta

    def initialize(params:, meta: {})
      @params = params
      @meta = meta
    end

    def subscribe
      channel_class = channel_type.camel_case.constantize
      if !defined?(ActiveRecord) || channel_class.is_a?(ActiveRecord::Base)
        raise_unknown_type_error!
      end
      channel_class.find_by(id: channel_id)
    rescue NameError
      raise_unknown_type_error!
    end

    def channel
      channel = params&.dig(:type)
      raise_empty_type_error! unless channel
      channel
    end

    def channel_id
      channel.split('/').last
    end

    def channel_type
      channel.split('/').first
    end

    private

    def raise_unknown_type_error!
      raise Logax::Action::UnknownType
    end

    def raise_empty_type_error!
      raise Logax::Action::EmtpyType
    end
  end
end
