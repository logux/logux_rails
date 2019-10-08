# frozen_string_literal: true

module Logux
  class Meta < Hash
    def initialize(source_hash = {})
      merge!(source_hash.stringify_keys)

      self['id'] ||= Logux.generate_action_id
      self['time'] ||= self['id'].split(' ').first
    end

    def node_id
      id.split(' ').second
    end

    def user_id
      node_id.split(':').first
    end

    def client_id
      node_id.split(':')[0..1].join(':')
    end

    def logux_order
      time + ' ' + id.split(' ')[1..-1].join(' ')
    end

    def time
      fetch('time')
    end

    def id
      fetch('id')
    end

    def undo_meta
      self.class.new(undo_meta_hash)
    end

    private

    RESEND_KEYS = %w[
      users
      nodes
      reasons
      channels
    ]

    private_constant :RESEND_KEYS

    def undo_meta_hash
      { status: 'processed' }
        .merge(slice(*RESEND_KEYS))
        .merge(clients: clients)
    end

    def clients
      result = [client_id]
      key?('clients') ? (result + self['clients']) : result
    end
  end
end
