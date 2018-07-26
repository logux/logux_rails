# frozen_string_literal: true

module Policies
  module Channels
    class Comment < Logux::Policy
      def subscribe?
        true
      end
    end
  end
end
