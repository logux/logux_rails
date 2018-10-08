# frozen_string_literal: true

module Logux
  module Test
    module Helpers
      extend ActiveSupport::Concern

      autoload :Receive, 'logux/test/helpers/receive'
      autoload :Send, 'logux/test/helpers/send'

      WebMock.after_request do |request, response|
        (request.uri.origin =~ /#{Logux.configuration.logux_host}/) || next
        Logux::Test::Store.instance.add_request(request: request,
                                                response: response)
      end

      included do |base|
        if %i[request controller].include? metadata[:type]
          base.include Logux::Test::Helpers::Receive
        end
        base.include Logux::Test::Helpers::Send
      end
    end
  end
end
