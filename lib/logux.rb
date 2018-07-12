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
  autoload :Params, 'logux/params'
  autoload :Action, 'logux/action'
  autoload :ClassFinder, 'logux/class_finder'
  autoload :ActionCaller, 'logux/action_caller'
  autoload :PolicyCaller, 'logux/policy_caller'
  autoload :Policy, 'logux/policy'
  autoload :Request, 'logux/request'
  autoload :Response, 'logux/response'
  autoload :Stream, 'logux/stream'
  autoload :Version, 'logux/version'

  configurable :logux_host, :verify_authorized, :password, :logger

  configuration_defaults do |config|
    config.logux_host = 'localhost:3333'
    config.verify_authorized = true
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

  def self.process_request(stream:, params:)
    stream_writer = Logux::Stream.new(stream)
    commands = params&.dig(:commands)
    authorized = process_authorization(stream: stream_writer, commands: commands)
    return unless authorized
    process_commands(stream: stream_writer, commands: commands)
  end

  def self.process_authorization(stream:, commands:)
    meta = nil
    authorized = commands.reduce(true) do |auth, command|
      params = Logux::Params.new(command[1])
      meta = Logux::Meta.new(command[2])
      next auth unless configuration.verify_authorized
      policy_caller = Logux::PolicyCaller.new(params: params, meta: meta)
      auth && policy_caller.call!
    end
    return(stream.write([:approved, meta.id]) || true) if authorized
    stream.write([:forbidden, meta.id]) || false
  end

  def self.process_commands(stream:, commands:)
    last_batch = commands.size + 1
    commands.map.with_index do |param, index|
      processed = process(param)
      stream.write(processed)
      stream.write(', ') if index != last_batch
    end
  end

  def self.logger
    configuration.logger
  end
end
