# frozen_string_literal: true

module Logux
  module Test
    module Helpers
      extend ActiveSupport::Concern

      WebMock.after_request do |request, response|
        (request.uri.origin =~ /#{Logux.configuration.logux_host}/) || next
        Logux::Test::Store.instance.add_request(request: request,
                                                response: response)
      end

      included do
        before do
          stub_request(:post, Logux.configuration.logux_host)
          Logux::Test::Store.instance.reset!
        end
      end

      def logux_store
        Logux::Test::Store.instance.requests
      end

      RSpec::Matchers.define :send_to_logux do |expected|
        match do |actual|
          before_state = logux_store.dup
          actual.call
          after_state = logux_store
          @difference = (after_state - before_state)
                        .map { |dif| dif[:body].deep_symbolize_keys }
          @difference.find do |state|
            case state
            when Hash
              state.merge(expected || {}).deep_symbolize_keys == state
            when Array
              ((state - (expected || []) | (expected || []) - state)).empty?
            else
              raise TypeError
            end
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
