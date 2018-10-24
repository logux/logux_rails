# frozen_string_literal: true

module Logux
  module Test
    class Store
      include Singleton

      def add(params)
        data << params
      end

      def data
        @data ||= []
      end

      def reset!
        @data = []
      end
    end
  end
end
