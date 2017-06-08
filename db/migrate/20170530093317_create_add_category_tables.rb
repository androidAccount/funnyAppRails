class CreateAddCategoryTables < ActiveRecord::Migration[5.0]
  def change
    create_table :add_category_tables, id: :uuid  do |t|
      t.string :cat_title ,null: false, default: ""
      t.timestamps
    end
  end
end
