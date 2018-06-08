# frozen_string_literal: true

module Logux
  class Meta < Hashie::Mash
    def with_time!
      self[:time] = _current_time
      self
    end

    def _current_time
      Time.now.to_i
    end
  end
end
