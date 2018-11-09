# frozen_string_literal: true

require 'rails/all'

ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require 'rspec/rails'

require 'combustion'

Combustion.path = 'spec/dummy'
Combustion.initialize! :all, database_reset: true, database_migrate: true

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    Rails.application.load_tasks
  end
end
