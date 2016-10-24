class AlterColumnPagesName < ActiveRecord::Migration[5.0]
  def change
  	change_column :pages, :title, :text
  end
end
