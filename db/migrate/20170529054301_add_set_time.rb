class AddSetTime < ActiveRecord::Migration[5.0]
  def change
    add_column :registration_codes, :sent_time, :datetime, null: false, default: Time.now
  end
end
