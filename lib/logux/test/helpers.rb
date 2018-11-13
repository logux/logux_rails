# frozen_string_literal: true

module Logux
  module Test
    module Helpers
      extend ActiveSupport::Concern

      included do
        before do
          Logux::Test::Store.instance.reset!
        end
      end

      def logux_store
        Logux::Test::Store.instance.data
      end

      def send_to_logux(*commands)
        Logux::Test::Matchers::SendToLogux.new(*commands)
      end

      def logux_approved(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['approved'], excludes: %w[forbidden error]
        )
      end

      def logux_processed(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['processed'], excludes: %w[forbidden error]
        )
      end

      def logux_forbidden(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['forbidden']
        )
      end

      def logux_errored(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['error']
        )
      end

      def logux_authenticated(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['authenticated']
        )
      end

      def logux_unauthorized(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['unauthorized']
        )
      end

      def logux_denied(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['denied']
        )
      end
    end
  end
end
