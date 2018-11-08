# frozen_string_literal: true

module Logux
  class ErrorRenderer
    attr_reader :exception

    def initialize(exception)
      @exception = exception
    end

    def message
      case exception
      when Logux::WithMetaError
        build_message(exception, exception.meta.id)
      when Logux::UnauthorizedError
        build_message(exception, exception.message)
      when StandardError
        # some runtime error that should be fixed
        render_stardard_error(exception)
      end
    end

    private

    def render_stardard_error(exception)
      if Logux.configuration.render_backtrace_on_error
        ['error', exception.backtrace]
      else
        ['error', 'Please look server logs for more information']
      end
    end

    def build_message(exception, additional_info)
      [
        exception.class.name.demodulize.camelize(:lower).gsub(/Error/, ''),
        additional_info
      ]
    end
  end
end
