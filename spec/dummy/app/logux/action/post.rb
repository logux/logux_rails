# frozen_string_literal: true

module Action
  class Post < Logux::Action
    def subscribe
      respond :processed
    end
  end
end
