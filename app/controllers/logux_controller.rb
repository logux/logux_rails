# frozen_string_literal: true

class LoguxController < ActionController::Base
  include ActionController::Live

  def create
    Logux.verify_request_meta_data(meta_params)
    logux_stream.write('[')
    Logux.process_batch(stream: logux_stream, batch: command_params)
  rescue => ex
    handle_processing_errors(ex)
  ensure
    logux_stream.write(']')
    logux_stream.close
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

  def logux_stream
    @logux_stream ||= Logux::Stream.new(response.stream)
  end

  def handle_processing_errors(exception)
    Logux.configuration.on_error.call(exception)
    Logux.logger.error("#{e}\n#{e.backtrace.join("\n")}")
  ensure
    logux_stream.write(Logux::ErrorRenderer.new(exception).message)
  end
end
