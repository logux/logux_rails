# frozen_string_literal: true

require_relative 'base'

module Logux
  module Test
    module Matchers
      class ResponseChunks < Base
        attr_reader :includes, :excludes, :meta

        def initialize(meta:, includes:, excludes: [])
          @meta = meta
          @includes = includes
          @excludes = excludes
        end

        def matches?(actual)
          @actual = JSON.parse(actual.body)

          match_includes? && match_excludes?
        end

        def failure_message
          data = "expected that #{pretty(@actual)} to has " \
            "#{includes.join(', ')} chunks"
          !excludes.empty? && data += " and doesn't" \
            " has #{excludes.join(', ')} chunks"
          data
        end

        private

        def match_includes?
          @actual.any? do |command|
            command.first.in?(includes) &&
              (meta.nil? || (meta.present? && command[1] == meta))
          end
        end

        def match_excludes?
          @actual.empty? || @actual.none? do |command|
            command.first.in?(excludes)
          end
        end
      end
    end
  end
end
