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

      RSpec::Matchers.define :send_to_logux do |expected|
        match do |actual|
          before_state = logux_store.dup
          actual.call
          after_state = logux_store
          @difference = (after_state - before_state)
                        .map { |d| JSON.parse(d) }
                        .map(&:deep_symbolize_keys)
          @difference.find do |state|
            state.merge(expected || {}).deep_symbolize_keys == state
          end
        end

        failure_message do
          "expected that #{pretty(@difference)} to include #{pretty(expected)}"
        end

        def supports_block_expectations?
          true
        end

        def pretty(obj)
          JSON.pretty_generate(obj)
        end
      end
    end
  end
end
