# frozen_string_literal: true

require 'action_controller'
require 'active_support'
require 'logux/rack'
require 'rails/engine'
require 'logux/engine'

module Logux
  autoload :Model, 'logux/model'

  configurable %i[
    action_watcher
    action_watcher_options
  ]

  configuration_defaults do |config|
    config.action_watcher = Logux::Model::UpdatesDeprecator
    config.action_watcher_options = { level: :error }
    config.logger = Rails.logger if defined?(Rails.logger)
    config.logger ||= ActiveSupport::Logger.new(STDOUT)
    config.on_error = proc {}
  end
end
