# frozen_string_literal: true

module Channels
  class Post < Logux::ChannelController
    def subscribe
      respond :processed
    end
  end
end
