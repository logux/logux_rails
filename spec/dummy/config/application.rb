# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end
