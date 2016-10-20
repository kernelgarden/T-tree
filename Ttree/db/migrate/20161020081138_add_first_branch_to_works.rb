class AddFirstBranchToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :first_branch, :integer
  end
end
