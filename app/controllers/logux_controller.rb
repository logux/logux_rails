# frozen_string_literal: true

class LoguxController < ActionController::Base
  def create
    Logux.verify_request_meta_data(meta_params)
    responce = Logux.process_batch(batch: command_params)
    Logux.logger.info("Write to Logux response: #{responce}")
    render json: responce
  rescue => ex
    render json: [handle_processing_errors(ex)]
  end

  private

  def unsafe_params
    params.to_unsafe_h
  end

  def command_params
    unsafe_params.dig('commands')
  end

  def meta_params
    unsafe_params&.slice(:version, :password)
  end

  def handle_processing_errors(exception)
    Logux.configuration.on_error.call(exception)
    Logux.logger.error("#{exception}\n#{exception.backtrace.join("\n")}")
  ensure
    Logux::ErrorRenderer.new(exception).message
  end
end
