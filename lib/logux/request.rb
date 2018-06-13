# frozen_string_literal: true

module Logux
  class Request
    attr_reader :client

    def initialize(client: Logux::Client.new)
      @client = client
    end

    def add_action(type, params: Logux::Params.new({}), meta: Logux::Meta.new({}))
      body = ['action']
      body << build_params(type: type, params: params)
      body << build_meta(meta: meta)
      client.post(body)
    end

    private

    def build_params(type:, params: {})
      params.merge(type: type)
    end

    def build_meta(meta: {})
      meta.with_time!
    end
  end
end
