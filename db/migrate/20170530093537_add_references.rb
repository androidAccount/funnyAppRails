class AddReferences < ActiveRecord::Migration[5.0]
  def change
    add_reference :articles, :add_category_tables, index: true
  end
end
