class CreateStarlists < ActiveRecord::Migration[5.0]
  def change
     create_table :starlists do |t|
       t.integer :user_id
       t.integer :work_id

       t.timestamps null: false
     end
     add_index :starlists, :user_id
     add_index :starlists, :work_id
     add_index :starlists, [:work_id, :user_id], unique: true
   end
end
