# frozen_string_literal: true

class LoguxController < ActionController::Base
  include ActionController::Live

  # rubocop:disable Style/RescueStandardError
  def create
    Logux.process_batch(logux_params) do |processed|
      response.stream.write(processed)
    end
  rescue
    response.stream.write([:internal_error].to_json)
  ensure
    response.stream.close
  end
  # rubocop:enable Style/RescueStandardError

  private

  def logux_params
    params.to_unsafe_h&.dig(:_json)
  end
end
