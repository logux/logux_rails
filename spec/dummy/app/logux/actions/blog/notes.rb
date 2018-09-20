# frozen_string_literal: true

module Actions
  module Blog
    class Notes < Logux::ActionController
      def add
        respond :processed
      end
    end
  end
end
