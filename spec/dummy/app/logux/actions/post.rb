# frozen_string_literal: true

module Actions
  class Post < Logux::ActionController
    def subscribe
      respond :processed
    end
  end
end
