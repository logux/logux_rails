# frozen_string_literal: true

require 'logux/rake_tasks'

module Logux
  class RakeTasks
    protected

    def default_actions_path
      ::Rails.root.join('app', 'logux', 'actions')
    end

    def default_channels_path
      ::Rails.root.join('app', 'logux', 'channels')
    end
  end
end

Logux::RakeTasks.new
