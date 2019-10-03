# frozen_string_literal: true

require 'action_controller'
require 'active_support'
require 'logux/rack'
require 'rails/engine'
require 'logux/engine'

module Logux
  autoload :Model, 'logux/model'

  configuration_defaults do |config|
    config.logger = ActiveSupport::Logger.new(STDOUT)
    if defined?(Rails) && Rails.respond_to?(:logger)
      config.logger = Rails.logger
    end
  end
end
