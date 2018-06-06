# frozen_string_literal: true

class LoguxController < ApplicationController
  def create
    render json: Logux.process_batch(logux_params)
  end

  private

  def logux_params
    params.to_unsafe_h&.dig(:events)
  end
end
