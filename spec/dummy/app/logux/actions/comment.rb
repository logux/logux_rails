# frozen_string_literal: true

module Actions
  class Comment < Logux::Action
    def add
      respond :processed
    end
  end
end
