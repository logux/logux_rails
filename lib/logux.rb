# frozen_string_literal: true

require 'configurations'
require 'rest-client'
require 'rails/engine'
require 'active_support'
require 'hashie/mash'
require 'logux/engine'

module Logux
  extend ActiveSupport::Autoload
  include Configurations

  class NoPolicyError < StandardError; end
  class NoActionError < StandardError; end

  autoload :Client, 'logux/client'
  autoload :Meta, 'logux/meta'
  autoload :Actions, 'logux/actions'
  autoload :BaseController, 'logux/base_controller'
  autoload :ActionController, 'logux/action_controller'
  autoload :ChannelController, 'logux/channel_controller'
  autoload :ClassFinder, 'logux/class_finder'
  autoload :ActionCaller, 'logux/action_caller'
  autoload :PolicyCaller, 'logux/policy_caller'
  autoload :Policy, 'logux/policy'
  autoload :Add, 'logux/add'
  autoload :Response, 'logux/response'
  autoload :Stream, 'logux/stream'
  autoload :Version, 'logux/version'

  configurable :logux_host, :verify_authorized, :password, :logger

  configuration_defaults do |config|
    config.logux_host = 'localhost:1338'
    config.verify_authorized = true
    config.logger = ActiveSupport::Logger.new(STDOUT)
    config.logger = Rails.logger if defined?(Rails) && Rails.respond_to?(:logger)
  end

  def self.add(type, meta: {})
    logux_add = Logux::Add.new
    logux_meta = Logux::Meta.new(meta)
    logux_add.call(type, meta: logux_meta)
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

  def self.process_action(action_params)
    action = Logux::Actions.new(action_params[1])
    meta = Logux::Meta.new(action_params[2])
    Logux::ActionCaller
      .new(action: action, meta: meta)
      .call!
      .format
  end

  def self.process(stream:, params:)
    actions = params&.dig(:commands)
    authorized = process_authorization(stream: stream, actions: actions)
    return unless authorized
    process_actions(stream: stream, actions: actions)
  end

  def self.process_authorization(stream:, actions:)
    meta = nil
    authorized = actions.reduce(true) do |auth, command|
      action = Logux::Actions.new(command[1])
      meta = Logux::Meta.new(command[2])
      policy_caller = Logux::PolicyCaller.new(action: action, meta: meta)
      auth && policy_caller.call!
    end
    return(stream.write([:approved, meta.id].to_json + ',') || true) if authorized
    stream.write([:forbidden, meta.id]) || false
  end

  def self.process_actions(stream:, actions:)
    last_batch = actions.size - 1
    actions.map.with_index do |action, index|
      processed = process_action(action).to_json
      processed += ',' if index != last_batch
      stream.write(processed)
    end
  end

  def self.logger
    configuration.logger
  end
end
