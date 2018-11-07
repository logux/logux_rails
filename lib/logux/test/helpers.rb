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

      def be_approved(*meta)
        Logux::Test::Matchers::BeApproved.new(*meta)
      end
    end
  end
end
