# frozen_string_literal: true

require_relative 'base'

module Logux
  module Test
    module Matchers
      class SendToLogux < Base
        def matches?(actual)
          @difference = state_changes_inside { actual.call }
          @difference.find do |state|
            state.merge(expected || {}).deep_symbolize_keys == state
          end
        end

        def failure_message
          "expected that #{pretty(@difference)} to include #{pretty(expected)}"
        end

        private

        def state_changes_inside
          before_state = Logux::Test::Store.instance.data.dup
          yield
          after_state = Logux::Test::Store.instance.data

          (after_state - before_state).map { |d| JSON.parse(d) }
                                      .map(&:deep_symbolize_keys)
        end
      end
    end
  end
end
