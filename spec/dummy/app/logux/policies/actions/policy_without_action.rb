# frozen_string_literal: true

module Policies
  module Actions
    class PolicyWithoutAction < Logux::Policy
      def create?
        true
      end
    end
  end
end
