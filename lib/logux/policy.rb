# frozen_string_literal: true

module Logux
  class Policy
    class UnauthorizedError < StandardError; end

    attr_reader :params, :meta

    def initialize(params:, meta:)
      @params = params
      @meta = meta
    end
  end
end
