class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.references :work, index:true, foreign_key: true

      t.timestamps null:false

    end
    add_index :branches, [:work_id, :created_at]
  end
end
