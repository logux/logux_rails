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

      def be_approved(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['approved'], excludes: %w[forbidden error]
        )
      end

      def be_processed(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['processed'], excludes: %w[forbidden error]
        )
      end

      def be_forbidden(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['forbidden']
        )
      end

      def be_errored(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['error']
        )
      end

      def be_authenticated(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['authenticated']
        )
      end

      def be_unauthorized(meta = nil)
        Logux::Test::Matchers::ResponseChunks.new(
          meta: meta, includes: ['unauthorized']
        )
      end
    end
  end
end
