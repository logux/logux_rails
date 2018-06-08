module Logux
  class Client
    def initialize(logux_host: Logux.configuration.logux_host)
      @logux_host = logux_host
    end

    def post(params)
      RestClient.post(logux_host,
                      params.to_json,
                      content_type: :json, accept: :json)
    end
  end
end
