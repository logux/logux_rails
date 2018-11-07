# frozen_string_literal: true

module Logux
  module Test
    module Matchers
      autoload :SendToLogux, 'logux/test/matchers/send_to_logux'
      autoload :BeApproved, 'logux/test/matchers/be_approved'
    end
  end
end
