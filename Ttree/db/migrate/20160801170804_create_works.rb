class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.string :name
      t.integer :user_id
      t.integer :team_id

      t.timestamps null: false
    end
    add_index :works, [:user_id, :created_at]
    add_index :works, [:team_id, :created_at]
  end
end
