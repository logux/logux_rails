class AddLoguxFieldsUpdatedAtToPosts < ActiveRecord::Migration[5.2]
  def up
    add_column :posts, :logux_fields_updated_at, :jsonb, null: true
    change_column_default :posts, :logux_fields_updated_at, {}
  end

  def down
    remove_column :posts, :logux_fields_updated_at
  end
end
