# frozen_string_literal: true

module Logux
  class AddBatch < Logux::Add

    private

    def prepare_data(data:, meta:)
      { version: 0,
        password: password,
        commands: data.map { |d| ['action', d, meta] } }
    end
  end
end
