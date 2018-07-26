# frozen_string_literal: true

module Actions
  class Comment < Logux::ActionController
    def add
      respond :processed
    end
  end
end
