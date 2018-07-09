# frozen_string_literal: true

module Logux
  class Request
    attr_reader :client, :version, :password

    def initialize(client: Logux::Client.new,
                   version: 0,
                   password: Logux.configuration.password)
      @client = client
      @version = version
      @password = password
    end

    def call(data, meta: Logux::Meta.new({}))
      prepared_data = prepare_data(data: data, meta: meta)
      Logux.logger.info("Logux add: #{JSON.pretty_generate(prepared_data.to_json)}")
      client.post(prepared_data)
    end

    private

    def prepare_data(data:, meta:)
      { version: 0,
        password: password,
        commands: data.map { |d| ['action', d, meta] } }
    end
  end
end
