class CreateUtRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :ut_relationships do |t|
      t.integer :member_id
      t.integer :team_id

      t.timestamps null:false
    end
    add_index :ut_relationships, :member_id
  	add_index :ut_relationships, :team_id
  	add_index :ut_relationships, [:member_id, :team_id], unique: true 
  end
end
