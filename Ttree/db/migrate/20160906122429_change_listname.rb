class ChangeListname < ActiveRecord::Migration[5.0]
  def change
    rename_column :starlists, :list, :work_id
  end
end
