# frozen_string_literal: true

class LoguxController < ActionController::Base
  def create
    render json: Logux.process_batch(logux_params)
  end

  private

  def logux_params
    params.to_unsafe_h&.dig(:_json)
  end
end
