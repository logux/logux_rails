# frozen_string_literal: true

module Logux
  module Process
    autoload :Batch, 'logux/process/batch'
    autoload :Access, 'logux/process/access'
    autoload :Init, 'logux/process/init'
    autoload :Action, 'logux/process/action'
    autoload :Auth,  'logux/process/auth'
  end
end
