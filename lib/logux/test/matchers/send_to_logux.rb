# frozen_string_literal: true

require_relative 'base'

module Logux
  module Test
    module Matchers
      class SendToLogux < Base
        def matches?(actual)
          @difference = state_changes_inside { actual.call }
          return !@difference.empty? if expected.empty?

          expected.all? do |ex|
            @difference.find do |state|
              state['commands'].any? do |c|
                match_commands?(c, ex)
              end
            end
          end
        end

        def failure_message
          "expected that #{pretty(@difference)} to include "\
            "commands #{pretty(expected)}"
        end

        private

        def state_changes_inside
          before_state = Logux::Test::Store.instance.data.dup
          yield
          after_state = Logux::Test::Store.instance.data

          (after_state - before_state).map { |d| JSON.parse(d) }
        end

        def match_commands?(stored_command, expected_command)
          # TOD: move matching to test command wrappers
          if expected_command.length < stored_command.length
            stored_command[0..(expected_command.length - 1)].to_json ==
              expected_command.to_json
          else
            stored_command.to_json == expected_command.to_json
          end
        end
      end
    end
  end
end
