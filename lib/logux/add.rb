# frozen_string_literal: true

module Logux
  class Add
    attr_reader :client, :version, :password

    def initialize(client: Logux::Client.new,
                   version: 0,
                   password: Logux.configuration.password)
      @client = client
      @version = version
      @password = password
    end

    def call(data, meta: {})
      prepared_data = prepare_data(data: data, meta: meta)
      Logux.logger.info('Logux add:', prepared_data)
      client.post(prepared_data)
    end

    private

    def prepare_data(data:, meta:)
      { version: 0,
        password: password,
        commands: format_data(data, meta) }
    end

    def format_data(data, meta)
      case data
      when Array
        data.map { |d| ['action', d, meta.merge(Logux::Meta.new)] }
      when Hash
        ['action', data, meta.merge(Logux::Meta.new)]
      else
        raise ArgumentError, data
      end
    end
  end
end
