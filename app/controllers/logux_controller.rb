# frozen_string_literal: true

class LoguxController < ActionController::Base
  include ActionController::Live

  # rubocop:disable Style/RescueStandardError
  def create
    Logux.verify_request_meta_data(meta_params)
    batch_size = command_params.size
    response.stream.write('[')
    command_params.map.with_index do |param, index|
      processed_data = Logux.process(param)
      response.stream.write(processed_data.to_json)
      response.stream.write(', ') if index + 1 != batch_size
    end
  rescue => e
    Logux.logger.error("#{e}\n#{e.backtrace.join("\n")}")
    response.stream.write([:internal_error].to_json)
  ensure
    response.stream.close
  end
  # rubocop:enable Style/RescueStandardError

  private

  def logux_params
    params.to_unsafe_h
  end

  def meta_params
    logux_params&.slice(:version, :password)
  end

  def command_params
    logux_params&.dig(:commands)
  end
end
