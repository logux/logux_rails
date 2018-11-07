# frozen_string_literal: true

require_relative 'base'

module Logux
  module Test
    module Matchers
      class BeApproved < Base
        def matches?(actual)
          @actual = JSON.parse(actual.body)

          be_approved?(@actual)
        end

        def failure_message
          "expected that #{pretty(@actual)} to be approved " \
            "and doesn't be errored of forbidden"
        end

        private

        def be_approved?(commands)
          meta = expected.first

          approved = commands.any? do |command|
            command.first == 'approved' &&
              (meta.nil? || (meta.present? && command[1] == meta))
          end

          approved && commands.none? do |command|
            command.first.in?(%w[forbidden error])
          end
        end
      end
    end
  end
end
