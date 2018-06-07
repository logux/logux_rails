# frozen_string_literal: true

module Action
  class Post < Logux::Action
    def subscribe
      ['processed', { id: meta[:id] }]
    end
  end
end
