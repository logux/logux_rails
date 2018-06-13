# frozen_string_literal: true

require 'configurations'
require 'rest-client'
require 'rails/engine'
require 'active_support'
require 'hashie/mash'
require 'logux/client'
require 'logux/meta'
require 'logux/params'
require 'logux/action'
require 'logux/request'
require 'logux/response'
require 'logux/version'
require 'logux/engine'

module Logux
  include Configurations

  configurable :logux_host

  configuration_defaults do |config|
    config.logux_host = 'localhost:3333'
  end

  def self.add_action(type, params: {}, meta: {})
    request = Logux::Request.new
    logux_params = Logux::Params.new(params)
    logux_meta = Logux::Meta.new(meta)
    request.add_action(type, params: logux_params, meta: logux_meta)
  end

  def self.process_batch(request_params)
    request_params.map { |params| process(params) }
  end

  def self.process(request_params)
    params = Logux::Params.new(request_params[1])
    meta = Logux::Meta.new(request_params[2])
    action_class = find_action_class_for(params)
    action = action_class.new(params: params, meta: meta)
    action.public_send(params.action_type).to_json
  end

  def self.find_action_class_for(params)
    action_name = if params.type == 'logux/subscribe'
                    params.channel_name
                  else
                    params.action_name
                  end

    "Actions::#{action_name.camelize}".constantize
  end

  private_class_method :find_action_class_for
end
