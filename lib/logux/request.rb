# frozen_string_literal: true

module Logux
  class Request
    attr_reader :client, :version

    def initialize(client: Logux::Client.new, version: 0)
      @client = client
      @version = version
    end

    def add_action(type, params: Logux::Params.new({}), meta: Logux::Meta.new({}))
      body = { version: version, password: password, commands: ['action'] }
      body[:commands] << build_params(type: type, params: params)
      body[:commands] << build_meta(meta: meta)
      client.post(body)
    end

    private

    def build_params(type:, params: {})
      params.merge(type: type)
    end

    def build_meta(meta: {})
      meta.with_time!
    end

    def password
      Logux.configuration.password
    end
  end
end
