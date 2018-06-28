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
require 'logux/action_caller'
require 'logux/policy'
require 'logux/request'
require 'logux/response'
require 'logux/version'
require 'logux/engine'

module Logux
  include Configurations
  class Logux::NoPolicyError < StandardError; end
  class Logux::NoActionError < StandardError; end

  configurable :logux_host, :verify_authorized

  configuration_defaults do |config|
    config.logux_host = 'localhost:3333'
    config.verify_authorized = false
  end

  def self.add_action(type, params: {}, meta: {})
    request = Logux::Request.new
    logux_params = Logux::Params.new(params)
    logux_meta = Logux::Meta.new(meta)
    request.add_action(type, params: logux_params, meta: logux_meta)
  end

  def self.process_batch(request_params)
    request_params.map do |params|
      processed_data = process(params)
      yield(processed_data.to_json) if block_given?
      processed_data
    end
  end

  def self.process(request_params)
    params = Logux::Params.new(request_params[1])
    meta = Logux::Meta.new(request_params[2])
    Logux::ActionCaller.new(params: params, meta: meta).call!
  rescue
    Logux::Response.new(:internal_error, params: params, meta: meta)
  end
end
