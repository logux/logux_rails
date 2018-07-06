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
      client.post(version: 0,
                  password: password,
                  commands: data.map { |d| ['action', d, meta] })
    end
  end
end
