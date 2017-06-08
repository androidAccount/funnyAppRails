class RegistrationCode < ApplicationRecord
  belongs_to :user
  def expired?
    (self.updated_at + 1.hours) <  0.seconds.from_now
  end
end
