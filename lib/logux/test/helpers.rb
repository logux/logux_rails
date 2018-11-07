# frozen_string_literal: true

require 'logux/test/matchers/send_to_logux'

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
    end
  end
end
