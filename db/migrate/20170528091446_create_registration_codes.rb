class CreateRegistrationCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :registration_codes, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.string :sms_code
      t.boolean :expired, default: false, null: false

      t.timestamps
    end
  end
end
