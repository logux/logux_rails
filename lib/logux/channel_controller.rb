# frozen_string_literal: true

module Logux
  class ChannelController < BaseController
    def subscribe
      add(subscribe_data, meta: subscribe_meta)
    end

    def initial_data
      []
    end

    def subscribe_meta
      { nodeIds: [node_id] }
    end
  end
end
