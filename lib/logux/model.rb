# frozen_string_literal: true

require_relative 'model/updater'
require_relative 'model/proxy'
require_relative 'model/secure_updates'
require_relative 'model/dsl'

module Logux
  module Model
    def self.included(base)
      base.send :alias_method, :update_attributes_unsafe, :update_attributes
      base.send :alias_method, :update_attribute_unsafe, :update_attribute

      base.include(SecureUpdates)
      base.extend(DSL)
    end

    def logux
      Proxy.new(self)
    end
  end
end
