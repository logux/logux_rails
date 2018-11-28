# frozen_string_literal: true

module Logux
  class ChannelController < BaseController
    def subscribe
      add(initial_data, meta: initial_meta)
    end

    def initial_data
      []
    end

    def initial_meta
      { clients: [meta.client_id] }
    end
  end
end
