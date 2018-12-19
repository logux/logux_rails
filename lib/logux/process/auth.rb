# frozen_string_literal: true

module Logux
  module Process
    class Auth
      attr_reader :chunk

      def initialize(chunk:)
        @chunk = chunk
      end

      def call
        if Logux.configuration.auth_rule.call(user_id, chunk.credentials)
          ['authenticated', chunk.auth_id]
        else
          ['denied', chunk.auth_id]
        end
      end

      private

      def user_id
        chunk.node_id.split(':').first
      end
    end
  end
end
