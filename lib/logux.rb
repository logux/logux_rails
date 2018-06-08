# frozen_string_literal: true

require 'configurations'
require 'rest-client'
require 'rails/engine'
require 'hashie/mash'
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
    Logux::ActionMatcher.new(params).action
  end

  private_class_method :find_action_class_for
end
