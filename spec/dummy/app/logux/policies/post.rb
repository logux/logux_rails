# frozen_string_literal: true

module Policies
  class Post < Logux::Policy
    def subscribe?
      true
    end

    def add?
      true
    end
  end
end
