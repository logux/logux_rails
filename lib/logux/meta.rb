# frozen_string_literal: true

module Logux
  class Meta < Hashie::Mash
    disable_warnings

    def initialize(source_hash = nil, default = nil, &blk)
      super
      self[:id] ||= Logux.generate_action_id
      self[:time] ||= Time.now.to_datetime.strftime('%Q')
    end

    def to_s
      to_h.to_s
    end

    def node_id
      id&.split(' ')&.second
    end

    def user_id
      id&.split(' ')&.second&.split(':')&.first
    end
  end
end
