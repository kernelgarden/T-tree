class CreateBrRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :br_relationships do |t|
      t.integer :highbranch_id
      t.integer :lowbranch_id

      t.timestamps null:false
    end
    add_index :br_relationships, :highbranch_id
  	add_index :br_relationships, :lowbranch_id
  	add_index :br_relationships, [:highbranch_id, :lowbranch_id], unique: true 
  end
end
