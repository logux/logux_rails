# frozen_string_literal: true

module Logux
  module Test
    module Matchers
      class SendToLogux
        attr_reader :expected

        def initialize(expected = nil)
          @expected = expected
        end

        def matches?(actual)
          before_state = Logux::Test::Store.instance.data.dup
          actual.call
          after_state = Logux::Test::Store.instance.data
          @difference = (after_state - before_state)
                        .map { |d| JSON.parse(d) }
                        .map(&:deep_symbolize_keys)
          @difference.find do |state|
            state.merge(expected || {}).deep_symbolize_keys == state
          end
        end

        def failure_message
          "expected that #{pretty(@difference)} to include #{pretty(expected)}"
        end

        def supports_block_expectations?
          true
        end

        private

        def pretty(obj)
          JSON.pretty_generate(obj)
        end
      end
    end
  end
end
