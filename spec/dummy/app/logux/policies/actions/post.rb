# frozen_string_literal: true

module Policies
  module Actions
    class Post < Logux::Policy
      def add?
        true
      end
    end
  end
end
