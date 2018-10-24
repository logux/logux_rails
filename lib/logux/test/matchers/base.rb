# frozen_string_literal: true

module Logux
  module Test
    module Matchers
      class Base
        attr_reader :expected

        def initialize(expected = nil)
          @expected = expected
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
