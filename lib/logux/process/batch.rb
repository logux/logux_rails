# frozen_string_literal: true

module Logux
  module Process
    class Batch
      attr_reader :batch

      def initialize(batch:)
        @batch = batch
      end

      def call
        preprocessed_batch.map.with_index do |chunk, index|
          case chunk[:type]
          when :access
            process_access(chunk: chunk.slice(:action, :meta))
          when :init
            process_init(chunk: chunk.slice(:action, :meta))
          when :action
            process_action(chunk: chunk.slice(:action, :meta))
          when :auth
            process_auth(chunk: chunk[:auth])
          end
        end
      end

      def process_access(chunk:)
        Logux::Process::Access.new(chunk: chunk).call
      end

      def process_init(chunk:)
        Logux::Process::Init.new(chunk: chunk).call
      end

      def process_action(chunk:)
        Logux::Process::Action.new(chunk: chunk).call
      end

      def process_auth(chunk:)
        Logux::Process::Auth.new(chunk: chunk).call
      end

      def preprocessed_batch
        @preprocessed_batch ||= batch.map do |chunk|
          case chunk[0]
          when 'init', 'access', 'action'
            preprocess_action(chunk)
          when 'auth'
            preprocess_auth(chunk)
          end
        end
      end

      def preprocess_action(chunk)
        { type: :action,
          action: Logux::Actions.new(chunk[1]),
          meta: Logux::Meta.new(chunk[2]) }
      end

      def preprocess_auth(chunk)
        { type: :auth,
          auth: Logux::Auth.new(node_id: chunk[1],
                                credentials: chunk[2],
                                auth_id: chunk[3]) }
      end
    end
  end
end
