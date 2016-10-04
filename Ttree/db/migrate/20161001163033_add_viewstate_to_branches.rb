class AddViewstateToBranches < ActiveRecord::Migration[5.0]
  def change
    add_column :branches, :viewstate, :boolean
  end
end
