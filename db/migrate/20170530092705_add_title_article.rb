class AddTitleArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :title, :string, default: ""
    add_column :articles, :image, :string, default: ""
    remove_column :articles, :name
  end
end
