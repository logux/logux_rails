# frozen_string_literal: true

module Logux
  class Policy
    class UnauthorizedError < StandardError; end

    attr_reader :action, :params, :meta

    def initialize(action:, params:, meta:)
      @action = action
      @params = params
      @meta = meta
    end
  end
end
