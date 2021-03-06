# frozen_string_literal: true

module Channels
  class Post < Logux::ChannelController
    def subscribe
      respond :forbidden if user_id == 1
      super
    end

    def initial_data
      [{ action: 'approve' }]
    end
  end
end
