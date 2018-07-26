# frozen_string_literal: true

module Policies
  module Actions
    class Comment < Logux::Policy
      def add?
        true
      end
    end
  end
end
