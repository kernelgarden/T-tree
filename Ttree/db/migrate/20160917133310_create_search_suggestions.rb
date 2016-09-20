class CreateSearchSuggestions < ActiveRecord::Migration[5.0]
  def change
    create_table :search_suggestions do |t|
      t.string :term
      t.integer :popularity

      t.timestamps
    end
  end
end
