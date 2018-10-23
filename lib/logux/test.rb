# frozen_string_literal: true

module Logux
  module Test
    class << self
      attr_accessor :http_requests_enabled

      def enable_http_requests!
        raise ArgumentError unless block_given?

        begin
          self.http_requests_enabled = true
          yield
        ensure
          self.http_requests_enabled = false
        end
      end
    end

    module Client
      def post(params)
        if Logux::Test.http_requests_enabled
          super(params)
        else
          Logux::Test::Store.instance.add(params.to_json)
        end
      end
    end

    autoload :Helpers, 'logux/test/helpers'
    autoload :Store, 'logux/test/store'
  end
end
Logux::Client.prepend Logux::Test::Client
