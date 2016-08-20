class CreateUnclassifiedpages < ActiveRecord::Migration[5.0]
  def change
    create_table :unclassifiedpages do |t|
      t.string :title
      t.text :url
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
    add_index :unclassifiedpages, [:user_id, :created_at]
  end
end
