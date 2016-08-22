class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.references :branch, foreign_key: true

      t.timestamps null: false
    end
    add_index :pages, [:branch_id, :created_at]
  end
end
