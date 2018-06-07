# frozen_string_literal: true

module Logux
  class Params
    extend Forwardable
    attr_reader :data

    def_delegator :@data, :[], :[]

    def initialize(data)
      @data = data
    end

    def type
      data[:type]
    end

    def action
      type.split('/').first
    end

    def event
      type.split('/').second
    end

    def channel
      data[:channel]
    end

    def channel_name
      channel.split('/').first
    end

    def channel_id
      channel.split('/').last
    end
  end
end
