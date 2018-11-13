# frozen_string_literal: true

module Logux
  module Model
    class Updater
      def initialize(model, meta, attributes)
        @model = model
        @meta = meta
        @attributes = attributes
      end

      def updated_attributes
        newer_updates.merge(logux_fields_updated_at: fields_updated_at)
      end

      private

      def fields_updated_at
        @fields_updated_at ||=
          newer_updates.slice(*tracked_fields)
                       .keys
                       .reduce(@model.logux_fields_updated_at) do |acc, attr|
                         acc.merge(attr => @meta.comparable_time)
                       end
      end

      def newer_updates
        @newer_updates ||= @attributes.reject do |attr, _|
          field_updated_at = @model.logux.updated_at(attr)
          field_updated_at && field_updated_at > @meta.comparable_time
        end
      end

      def tracked_fields
        @model.class.logux_crdt_mapped_attributes
      end
    end
  end
end
