# frozen_string_literal: true

module Logux
  def self.process_batch(request_params)
    request_params.map { |params| process(params) }
  end

  def self.process(request_params)
    command_type, command_params, meta_data = request_params
  end
end
