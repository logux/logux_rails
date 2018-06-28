# frozen_string_literal: true

module Logux
  class Params < Hashie::Mash
    disable_warnings

    def action_name
      type.split('/')[0]
    end

    def action_type
      type.split('/')[1]
    end

    def channel_name
      channel.split('/')[0]
    end

    def channel_id
      channel.split('/').last
    end
  end
end
