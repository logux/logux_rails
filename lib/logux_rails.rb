# frozen_string_literal: true

require 'action_controller'
require 'active_support'
require 'logux/rack'
require 'rails/engine'
require 'logux/engine'

module Logux
  autoload :Model, 'logux/model'

  configuration_defaults do |config|
    config.logger = Rails.logger if defined?(Rails.logger)
    config.logger ||= ActiveSupport::Logger.new(STDOUT)
  end
end
