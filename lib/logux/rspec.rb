module Logux
  module RSpec
    extend ActiveSupport::Concern

    included do |base|
      base.before do
        stub_request(:post, Logux.configuration.logux_host)
      end
    end

  end
end
