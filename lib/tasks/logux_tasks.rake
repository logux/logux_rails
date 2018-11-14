# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :logux do
  desc 'Lists all Logux action types'
  task actions: :environment do
    Dir[Rails.root.join('app', 'logux', 'actions', '**', '*.rb')].each do |file|
      require file
    end

    output = [%w[action.type Class#method]]
    Logux::ActionController.descendants.sort_by(&:name).each do |klass|
      klass.instance_methods(false).sort.each do |action|
        output << [
          "#{klass.name.gsub(/^Actions::/, '').underscore}/#{action}",
          "#{klass.name}##{action}"
        ]
      end
    end

    first_column_length = output.map(&:first).max_by(&:length).length
    output.each do |action, klass_name|
      puts "#{action.rjust(first_column_length, ' ')} #{klass_name}"
    end
  end

  desc 'Lists all Logux channels'
  task channels: :environment do
    path = Rails.root.join('app', 'logux', 'channels', '**', '*.rb')
    Dir[path].each { |file| require file }

    output = [%w[channel Class]]
    Logux::ChannelController.descendants.map(&:name).sort.each do |klass_name|
      output << [
        klass_name.gsub(/^Channels::/, '').underscore,
        klass_name
      ]
    end

    first_column_length = output.map(&:first).max_by(&:length).length
    output.each do |channel, klass_name|
      puts "#{channel.rjust(first_column_length, ' ')} #{klass_name}"
    end
  end
end
# rubocop:enable Metrics/BlockLength
