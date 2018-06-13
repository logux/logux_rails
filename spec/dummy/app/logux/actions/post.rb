# frozen_string_literal: true

module Actions
  class Post < Logux::Action
    def subscribe
      respond :processed
    end
  end
end
