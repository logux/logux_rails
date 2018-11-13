# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record/migration/migration_generator'

module Logux
  module Generators
    class ModelGenerator < ::ActiveRecord::Generators::Base # :nodoc:
      source_root File.expand_path('templates', __dir__)

      class_option :nullable,
                   type: :boolean,
                   optional: true,
                   desc: 'Define whether field should have not-null constraint'

      def generate_migration
        migration_template(
          'migration.rb.erb',
          "db/migrate/add_logux_fields_updated_at_to_#{plural_table_name}.rb"
        )
      end

      def nullable?
        options.fetch(:nullable, false)
      end
    end
  end
end
