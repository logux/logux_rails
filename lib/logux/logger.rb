# frozen_string_literal: true

module Logux
  class Logger
    def self.info(message, data = "")
      msg = message.light_yellow
      if data.present? && data.is_a?(Hash)
        msg = msg + ': '.light_yellow +
         JSON.pretty_generate(data).light_white.on_light_blue
      end

      logger.info(msg)
    end

    def self.error(message)
      logger.error(message)
    end

    def self.warn(message)
      logger.warn(message)
    end

    def self.logger
      Logux.configuration.logger
    end
  end
end
