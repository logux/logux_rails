# frozen_string_literal: true

module Logux
  class Stream
    attr_reader :stream

    def initialize(stream)
      @stream = stream
    end

    def write(payload)
      processed_payload = process(payload)
      Logux.logger.info("Write to logux: #{processed_payload}")
      stream.write(processed_payload)
    end

    private

    def process(payload)
      return payload if payload.is_a?(::String)
      payload.to_json
    end
  end
end
