# frozen_string_literal: true

module Logux
  class Policy
    class UnauthorizedError < StandardError; end

    attr_reader :action, :meta

    def initialize(action:, meta:)
      @action = action
      @meta = meta
    end
  end
end
