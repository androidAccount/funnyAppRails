class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
       t.string :article_id ,null: false, default: ""
       t.string :user_id ,null: false, default: ""
      t.timestamps
    end
  end
end
