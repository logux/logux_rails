# frozen_string_literal: true

module Logux
  module Process
    class Action
      attr_reader :chunk

      def initialize(chunk:)
        @chunk = chunk
      end

      def call
        Logux::ActionCaller.new(
          action: action_from_chunk,
          meta: meta_from_chunk
        ).call!
        ['processed', meta_from_chunk.id]
      end

      def action_from_chunk
        @action_from_chunk ||= chunk[:action]
      end

      def meta_from_chunk
        @meta_from_chunk ||= chunk[:meta]
      end
    end
  end
end
