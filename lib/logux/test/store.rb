# frozen_string_literal: true

module Logux
  module Test
    class Store
      include Singleton

      def add_request(action)
        requests << action
      end

      def requests
        @requests ||= []
      end

      def reset!
        @requests = nil
      end
    end
  end
end
