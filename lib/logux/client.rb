# frozen_string_literal: true

module Logux
  class Client
    attr_reader :logux_host

    def initialize(logux_host: Logux.configuration.logux_host)
      @logux_host = logux_host
    end

    def post(params)
      client.post(params.to_json,
                  content_type: :json,
                  accept: :json)
    end

    def client
      @client ||= RestClient::Resource.new(logux_host, verify_ssl: false)
    end
  end
end
