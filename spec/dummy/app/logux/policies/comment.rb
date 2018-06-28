# frozen_string_literal: true

module Policies
  class Comment < Logux::Policy
    def subscribe?
      true
    end

    def add?
      true
    end
  end
end
