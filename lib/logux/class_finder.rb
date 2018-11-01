# frozen_string_literal: true

module Logux
  class ClassFinder
    attr_reader :action, :meta

    def initialize(action:, meta:)
      @action = action
      @meta = meta
    end

    def find_action_class
      "#{class_namespace}::#{class_name}".constantize
    rescue NameError
      message = %(
        Unable to find action #{class_name.camelize}
        Should be in app/logux/#{class_namespace.downcase}/#{class_path}.rb
      )
      raise Logux::UnknownActionError.new(message, meta: meta) if action?
      raise Logux::UnknownChannelError.new(message, meta: meta)
    end

    def find_policy_class
      "Policies::#{class_namespace}::#{class_name}".constantize
    rescue NameError
      message = %(
        Unable to find action policy #{class_name.camelize}
        Should be in app/logux/policies/#{class_namespace.downcase}/#{class_path}.rb
      )
      raise Logux::UnknownActionError.new(message, meta: meta) if action?
      raise Logux::UnknownChannelError.new(message, meta: meta)
    end

    def class_name
      if subscribe?
        action.channel_name.camelize
      else
        action.type.split('/')[0..-2].map(&:camelize).join('::')
      end
    end

    private

    def class_namespace
      return 'Channels' if subscribe?
      'Actions'
    end

    def subscribe?
      action.type == 'logux/subscribe'
    end

    def action?
      !subscribe?
    end

    def class_path
      "#{class_namespace}::#{class_name}".underscore
    end
  end
end
