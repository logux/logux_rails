# frozen_string_literal: true

require 'logux/meta'
require 'logux/params'
require 'logux/action'

module Logux
  def self.process_batch(request_params)
    request_params.map { |params| process(params) }
  end

  def self.process(request_params)
    params = Logux::Params.new(request_params[1])
    meta = Logux::Meta.new(request_params[2])
    action_class = find_action_class_for(params)
    action = action_class.new(params: params, meta: meta)
    action.public_send(params.event)
  end

  def self.find_action_class_for(params)
    "Action::#{params.action.camelcase}".constantize
  end

  private_class_method :find_action_class_for
end
