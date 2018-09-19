# frozen_string_literal: true

namespace :logux do
  desc 'Lists all Logux action types'
  task actions: :environment do
    Dir[Rails.root.join('app', 'logux', 'actions', '**', '*.rb')].each do |file|
      require file
    end

    puts "action.type\tClass#method"
    Logux::ActionController.descendants.each do |controller_klass|
      controller_klass.instance_methods(false).each do |action|
        action_type = "#{controller_klass.name.demodulize.underscore}/#{action}"
        puts "#{action_type}\t#{controller_klass.name}##{action}"
      end
    end
  end
end
