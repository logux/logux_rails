# frozen_string_literal: true

module Logux
  class Request
    class UnpermittedKey < StandardError; end

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
      raise_unpermitted_key! if params.key?(:type)
      params.merge(type: type)
    end

    def build_meta(meta: {})
      raise_unpermitted_key! if meta.key?(:time)
      meta.with_time!
    end

    def raise_unpermitted_key!
      raise UnpermittedKey
    end
  end
end
