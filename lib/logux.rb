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
require 'logux/class_finder'
require 'logux/action_caller'
require 'logux/policy'
require 'logux/request'
require 'logux/response'
require 'logux/version'
require 'logux/engine'

module Logux
  include Configurations
  class NoPolicyError < StandardError; end
  class NoActionError < StandardError; end

  configurable :logux_host, :verify_authorized, :password, :logger

  configuration_defaults do |config|
    config.logux_host = 'localhost:3333'
    config.verify_authorized = false
    config.logger = ActiveSupport::Logger.new(STDOUT)
    config.logger = Rails.logger if defined?(Rails) && Rails.respond_to?(:logger)
  end

  def self.add_action(type, params: {}, meta: {})
    request = Logux::Request.new
    logux_params = Logux::Params.new(params)
    logux_meta = Logux::Meta.new(meta)
    request.add_action(type, params: logux_params, meta: logux_meta)
  end

  def self.verify_request_meta_data(meta_params)
    if Logux.configuration.password.nil?
      logger.warn(%(Please, add passoword for logux server:
                          Logux.configure do |c|
                            c.password = 'your-password'
                          end))
    end
    auth = Logux.configuration.password == meta_params&.dig(:password)
    raise unless auth
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
    Logux::ActionCaller
      .new(params: params, meta: meta)
      .call!
      .format
  end

  def self.logger
    configuration.logger
  end
end
