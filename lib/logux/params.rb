# frozen_string_literal: true

module Logux
  class Params < Hashie::Mash
    disable_warnings

    def action_name
      type&.split('/')&.dig(0)
    end

    def action_type
      type&.split('/')&.last
    end

    def channel_name
      channel&.split('/')&.dig(0)
    end

    def channel_id
      channel&.split('/')&.last
    end

    def to_s
      to_h.to_s
    end
  end
end
