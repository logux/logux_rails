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

    def call(action, meta)
      prepared_data = prepare_data(action, meta)
      Logux.logger.info('Logux add:', prepared_data)
      client.post(prepared_data)
    end

    private

    def prepare_data(action, meta)
      {
        version: 0,
        password: password,
        commands: [['action', action, meta]]
      }
    end
  end
end
