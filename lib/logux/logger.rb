# frozen_string_literal: true

module Logux
  module Logger
    class << self
      def debug(message, data = '')
        msg = message.light_yellow.bold
        if data.present? && data.is_a?(Hash)
          msg += ': '.light_yellow.bold +
                 JSON.pretty_generate(data).yellow
        end

        logger.debug(msg)
      end

      delegate :warn, :error, to: :logger

      def logger
        Logux.configuration.logger
      end
    end
  end
end
