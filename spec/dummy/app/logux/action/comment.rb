# frozen_string_literal: true

module Action
  class Comment < Logux::Action
    def add
      respond :processed
    end
  end
end
