module Logux
  class Response
    attr_reader :status, :params, :meta, :custom_data

    def initialize(status, params:, meta:, custom_data: nil)
      @status = status
      @params = params
      @meta = meta
      @custom_data = custom_data
    end

    def to_json
      [status, custom_data || meta.slice(:id)]
    end
  end
end
