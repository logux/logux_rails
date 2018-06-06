# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
  end
end
