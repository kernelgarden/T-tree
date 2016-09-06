class CreateStarlists < ActiveRecord::Migration[5.0]
  def change
    create_table :starlists do |t|
    	t.integer :list
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
    add_index :starlists, [:user_id, :created_at]
  end
end
