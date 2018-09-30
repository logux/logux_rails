# frozen_string_literal: true

module Logux
  module Test
    class Store
      include Singleton

      def add_request(action)
        parsed_body = parse_body(action[:request]&.body)
        requests << action.merge(body: parsed_body)
      end

      def requests
        @requests ||= []
      end

      def reset!
        @requests = []
      end

      private

      def parse_body(body)
        JSON.parse(body)
      rescue JSON::ParserError, TypeError
        {}
      end
    end
  end
end
