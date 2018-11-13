# frozen_string_literal: true

module Logux
  module Model
    module DSL
      def logux_crdt_map_attributes(*attributes)
        @logux_crdt_mapped_attributes = attributes
      end

      def logux_crdt_mapped_attributes
        @logux_crdt_mapped_attributes ||= []
      end
    end
  end
end
