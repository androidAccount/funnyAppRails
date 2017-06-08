class ChangeColumnType < ActiveRecord::Migration[5.0]
  def change
	change_column :articles, :add_category_tables_id, :string
  end
end
