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
    end
  end
end
