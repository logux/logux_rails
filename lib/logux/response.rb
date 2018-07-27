# frozen_string_literal: true

module Logux
  class Response
    attr_reader :status, :action, :meta, :custom_data

    def initialize(status, action:, meta:, custom_data: nil)
      @status = status
      @action = action
      @meta = meta
      @custom_data = custom_data
    end

    def format
      [status, custom_data || meta.slice(:id)]
    end
  end
end
