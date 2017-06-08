class AddPopulaVistArticle < ActiveRecord::Migration[5.0]
  def change
	add_column :articles, :popular, :integer, null: false, default: 0
	add_column :articles, :visit, :integer, null: false, default: 0
  end
end
