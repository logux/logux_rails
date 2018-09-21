# frozen_string_literal: true

require 'rails/all'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment.rb', __dir__)
require 'spec_helper'
require 'rspec/rails'

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    Rails.application.load_tasks
  end
end
