# frozen_string_literal: true

module Logux
  module Process
    class Auth
      def initialize(stream:, chunk:)
        @stream = stream
        @chunk = chunk
      end

      def call
        authed = Logux.configuration.auth_rule.call(chunk)
        return stream.write(['authenticated', chunk.auth_id]) if authed
        stream.write(['denied', chunk.auth_id])
      end
    end
  end
end
