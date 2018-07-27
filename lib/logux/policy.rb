# frozen_string_literal: true

module Logux
  class Policy
    class UnauthorizedError < StandardError; end

    attr_reader :actions, :meta

    def initialize(actions:, meta:)
      @actions = actions
      @meta = meta
    end
  end
end
