# frozen_string_literal: true

module Logux
  module Model
    module SecureUpdates
      def update_attributes(attributes)
        check_logux_attributes(attributes.keys)
        update_attributes_unsafe(attributes)
      end

      def update_attribute(attribute, value)
        check_logux_attributes([attribute])
        update_attribute_unsafe(attribute, value)
      end

      private

      def check_logux_attributes(attributes)
        logux_attributes = attributes & self.class.logux_crdt_mapped_attributes
        return if logux_attributes.empty?

        pluralized_attributes = 'attribute'.pluralize(logux_attributes.count)

        raise <<~TEXT
          Logux tracked #{pluralized_attributes} (#{logux_attributes.join(', ')}) should be updated using model.logux.update(...)
        TEXT
      end
    end
  end
end
