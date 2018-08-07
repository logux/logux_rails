# frozen_string_literal: true

module Logux
  module Process
    class Batch
      attr_reader :stream, :batch

      def initialize(stream:, batch:)
        @stream = stream
        @batch = batch
      end

      def call
        last_chunk = batch.size - 1
        preprocessed_batch.map.with_index do |chunk, index|
          case chunk[:type]
          when :action
            process_action(chunk: chunk.slice(:action, :meta))
          when :auth
            process_auth(chunk: chunk.slice(:auth))
          end
          stream.write(',') if index != last_chunk
        end
      end

      def process_action(chunk:)
        Logux::Process::Action.new(stream: stream, chunk: chunk).call
      end

      def process_auth(chunk:)
        Logux::Process::Auth.new(stream: stream, chunk: chunk).call
      end

      def preprocessed_batch
        @preprocessed_batch ||= batch.map do |chunk|
          case chunk[0]
          when 'action'
            { type: :action,
              action: Logux::Actions.new(chunk[1]),
              meta: Logux::Meta.new(chunk[2]) }
          when 'auth'
            { type: :auth,
              auth: Logux::Auth.new(node_id: chunk[1],
                                    credentials: chunk[2],
                                    auth_id: chunk[3]) }
          end
        end
      end
    end
  end
end
