# frozen_string_literal: true

module Logux
  module Logger
    class << self
      def info(message, data = '')
        msg = message.light_yellow.bold
        if data.present? && data.is_a?(Hash)
          msg += ': '.light_yellow.bold +
                 JSON.pretty_generate(data).yellow
        end

        logger.info(msg)
      end

      delegate :warn, :error, to: :logger

      def logger
        Logux.configuration.logger
      end
    end
  end
end
