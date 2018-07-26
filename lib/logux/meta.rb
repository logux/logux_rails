# frozen_string_literal: true

module Logux
  class Meta < Hashie::Mash
    disable_warnings

    def initialize(source_hash = nil, default = nil, &blk)
      super
      self[:time] ||= Time.zone&.now&.to_i || Time.now.to_i
    end

    def to_s
      to_h.to_s
    end
  end
end
