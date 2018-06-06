# frozen_string_literal: true

module Action
  class Comment < Logux::Action
    def add
      ['processed', 1]
    end
  end
end
