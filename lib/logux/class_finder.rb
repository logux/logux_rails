# frozen_string_literal: true

module Logux
  class ClassFinder
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def find_action_class
      "Actions::#{class_name.camelize}".constantize
    rescue NameError
      raise Logux::NoActionError, %(
        Unable to find action #{class_name.camelize}
        Should be in app/logux/actions/#{class_path}.rb
      )
    end

    def find_policy_class
      "Policies::#{class_name.camelize}".constantize
    rescue NameError
      raise Logux::NoPolicyError, %(
        Unable to find policy #{class_name.camelize}
        Should be in app/logux/policies/#{class_path}.rb
      )
    end

    def class_name
      if params.type == 'logux/subscribe'
        params.channel_name
      else
        params.type.split('/')[0..-2].map(&:camelize).join('::')
      end
    end

    def class_path; end
  end
end
