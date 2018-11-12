# frozen_string_literal: true

module Logux
  module Test
    module Matchers
      autoload :SendToLogux, 'logux/test/matchers/send_to_logux'
      autoload :ResponseChunks, 'logux/test/matchers/response_chunks'
    end
  end
end
