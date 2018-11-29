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
          expected_command.each_with_index.all? do |part, index|
            part.stringify_keys! if part.is_a?(Hash)
            matcher = if part.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher)
                        part
                      else
                        RSpec::Matchers::BuiltIn::Eq.new(part)
                      end
            matcher.matches?(stored_command[index])
          end
        end
      end
    end
  end
end
