# frozen_string_literal: true

module Logux
  module Helper
    def self.add(type:, **_options)
      RestClient.post(Logux.configuration.logux_host,
                      params.to_json,
                      content_type: :json, accept: :json)
    end
  end
end
