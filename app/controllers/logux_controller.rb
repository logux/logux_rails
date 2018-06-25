# frozen_string_literal: true

class LoguxController < ActionController::Base
  include ActionController::Live

  def create
    Logux.process_batch(logux_params) do |processed|
      response.stream.write(processed)
    end
  ensure
    response.stream.close
  end

  private

  def logux_params
    params.to_unsafe_h&.dig(:_json)
  end
end
