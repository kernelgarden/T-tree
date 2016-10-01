class AddViewwidthToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :viewwidth, :integer
  end
end
