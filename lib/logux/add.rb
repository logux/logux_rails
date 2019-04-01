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

    def call(commands)
      return if commands.empty?

      prepared_data = prepare_data(commands)
      Logux.logger.debug('Logux add:', prepared_data)
      client.post(prepared_data)
    end

    private

    def prepare_data(commands)
      {
        version: 0,
        password: password,
        commands: commands.map do |command|
          action = command.first
          meta = command[1]
          ['action', action, meta || Meta.new]
        end
      }
    end
  end
end
