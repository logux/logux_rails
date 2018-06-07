module Logux
  module Helper
    def self.add(params)
      RestClient.post(Logux.configuration.logux_host,
                      params.to_json,
                      content_type: :json, accept: :json)
    end
  end
end
