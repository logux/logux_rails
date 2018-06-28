# frozen_string_literal: true

module Logux
  class Params < Hashie::Mash
    class EmptyType < StandardError; end
    class EmptyChannel < StandardError; end

    disable_warnings

    def action_name
      raise_empty_type_error!(__method__) if type.nil?
      type.split('/')[0]
    end

    def action_type
      raise_empty_type_error!(__method__) if type.nil?
      type.split('/')[1]
    end

    def channel_name
      raise_empty_channel_error!(__method__) if channel.nil?
      channel.split('/')[0]
    end

    def channel_id
      raise_empty_channel_error!(__method__) if channel.nil?
      channel.split('/').last
    end

    private

    def raise_empty_type_error!(message = '')
      raise Logux::Params::EmptyType, message
    end

    def raise_empty_channel_error!(message = '')
      raise Logux::Params::EmptyChannel, message
    end
  end
end
