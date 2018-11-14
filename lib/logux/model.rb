# frozen_string_literal: true

require_relative 'model/updater'
require_relative 'model/proxy'
require_relative 'model/dsl'
require_relative 'model/updates_deprecator'

module Logux
  module Model
    class InsecureUpdateError < StandardError; end

    def self.included(base)
      base.extend(DSL)

      base.before_update :touch_logux_id_for_changes,
                         unless: -> { changes.key?('logux_fields_updated_at') }
    end

    def logux
      Proxy.new(self)
    end

    private

    def touch_logux_id_for_changes
      attributes = changed.each_with_object({}) do |attr, res|
        res[attr] = send(attr)
      end

      updater = Updater.new(model: self, attributes: attributes)
      self.logux_fields_updated_at = updater.updated_attributes

      ActiveSupport::Notifications.instrument(
        Logux::Model::UpdatesDeprecator::EVENT,
        model_class: self.class,
        changed: changed
      )
    end
  end
end
