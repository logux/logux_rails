# frozen_string_literal: true

module Logux
  module Process
    class Auth
      attr_reader :stream, :chunk

      def initialize(stream:, chunk:)
        @stream = stream
        @chunk = chunk
      end

      def call
        authed = Logux.configuration.auth_rule.call(user_id, chunk.credentials)
        return stream.write(['authenticated', chunk.auth_id]) if authed

        stream.write(['denied', chunk.auth_id])
      end

      private

      def user_id
        chunk.node_id.split(':').first
      end
    end
  end
end
