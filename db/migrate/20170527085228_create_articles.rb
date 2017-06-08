class CreateArticles < ActiveRecord::Migration[5.0]
  def change
enable_extension 'uuid-ossp'
    create_table :articles, id: :uuid  do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
