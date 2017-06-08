class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.string :first_name, null: false, default: ""
      t.string :last_name,null: false, default: ""
      t.string :national_code ,null: false, default: ""
      t.string :image 
      t.boolean :gender, defalt: true
      t.timestamps
    end
  end
end
