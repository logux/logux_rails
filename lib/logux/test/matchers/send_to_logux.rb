# frozen_string_literal: true

require_relative 'base'

module Logux
  module Test
    module Matchers
      class SendToLogux < Base
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
      end
    end
  end
end
