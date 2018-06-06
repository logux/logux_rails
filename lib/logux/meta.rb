# frozen_string_literal: true

module Logux
  class Meta
    extend Forwardable
    attr_reader :data

    def_delegator :@data, :[], :[]

    def initialize(data)
      @data = data
    end
  end
end
