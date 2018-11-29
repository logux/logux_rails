# frozen_string_literal: true

module Logux
  class Meta < Hashie::Mash
    disable_warnings

    def initialize(source_hash = nil, default = nil, &blk)
      super
      self[:id] ||= Logux.generate_action_id
      self[:time] ||= self[:id].split(' ').first
    end

    def to_s
      to_h.to_s
    end

    def node_id
      self[:id].split(' ').second
    end

    def user_id
      node_id.split(':').first
    end

    def client_id
      node_id.split(':')[0..1].join(':')
    end

    def logux_order
      self[:time] + ' ' + self[:id].split(' ')[1..-1].join(' ')
    end
  end
end
