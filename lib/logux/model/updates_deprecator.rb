# frozen_string_literal: true

module Logux
  module Model
    class UpdatesDeprecator
      EVENT = 'logux.insecure_update'

      class << self
        def watch(args = {}, &block)
          new(args).watch(&block)
        end
      end

      def initialize(level: :warn)
        @level = level
      end

      def watch(&block)
        callback = lambda(&method(:handle_insecure_update))
        ActiveSupport::Notifications.subscribed(callback, EVENT, &block)
      end

      private

      # rubocop:disable Naming/UncommunicativeMethodParamName
      def handle_insecure_update(_, _, _, _, args)
        attributes = args[:changed].map(&:to_sym) - [:logux_fields_updated_at]
        insecure_attributes =
          attributes & args[:model_class].logux_crdt_mapped_attributes
        return if insecure_attributes.empty?

        notify_about_insecure_update(insecure_attributes)
      end
      # rubocop:enable Naming/UncommunicativeMethodParamName

      def notify_about_insecure_update(insecure_attributes)
        pluralized_attributes = 'attribute'.pluralize(insecure_attributes.count)

        message = <<~TEXT
          Logux tracked #{pluralized_attributes} (#{insecure_attributes.join(', ')}) should be updated using model.logux.update(...)
        TEXT

        case @level
        when :warn
          ActiveSupport::Deprecation.warn(message)
        when :error
          raise InsecureUpdateError, message
        end
      end
    end
  end
end
