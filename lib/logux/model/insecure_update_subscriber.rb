# frozen_string_literal: true

module Logux
  module Model
    class InsecureUpdateSubscriber
      # rubocop:disable Naming/UncommunicativeMethodParamName
      def call(_, _, _, _, args)
        model_class = args[:model_class]
        attributes = args[:changed].map(&:to_sym) - [:logux_fields_updated_at]
        check_update_is_secure(model_class, attributes)
      end
      # rubocop:enable Naming/UncommunicativeMethodParamName

      private

      def check_update_is_secure(model_class, attributes)
        logux_attributes =
          attributes & model_class.logux_crdt_mapped_attributes
        return if logux_attributes.empty?

        pluralized_attributes = 'attribute'.pluralize(logux_attributes.count)

        raise InsecureUpdateError, <<~TEXT
          Logux tracked #{pluralized_attributes} (#{logux_attributes.join(', ')}) should be updated using model.logux.update(...)
        TEXT
      end
    end
  end
end
