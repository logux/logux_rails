# frozen_string_literal: true

module Logux
  class ClassFinder
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def find_action_class
      "#{class_namespace}::#{class_name}".constantize
    rescue NameError
      Logux.logger.warn %(
        Unable to find action #{class_name.camelize}
        Should be in app/logux/actions/#{class_path}.rb
      )
      nil
    end

    def find_policy_class
      "Policies::#{class_namespace}::#{class_name}".constantize
    rescue NameError
      Logux.logger.warn %(
        Unable to find policy #{class_name.camelize}
        Should be in app/logux/policies/#{class_path}.rb
      )
      nil
    end

    def class_namespace
      return 'Channels' if params.type == 'logux/subscribe'
      'Actions'
    end

    def class_name
      if params.type == 'logux/subscribe'
        params.channel_name.camelize
      else
        params.type.split('/')[0..-2].map(&:camelize).join('::')
      end
    end

    def class_path
      "#{class_namespace}::#{class_name}".underscore
    end
  end
end
