class AddEnable < ActiveRecord::Migration[5.0]
  def change
	add_column :users, :enabled, :boolean, defalt: false
	add_column :users, :admin, :boolean, defalt: false
  end
end
