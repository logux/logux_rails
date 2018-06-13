# frozen_string_literal: true

module Logux
  class Meta < Hashie::Mash
    disable_warnings

    def with_time!
      self[:time] = _current_time
      self
    end

    def _current_time
      Time.now.to_i
    end
  end
end
