class User < ApplicationRecord
devise :database_authenticatable, :registerable, :lockable,
         :trackable, :validatable

has_one :registration_code
has_many :articles
has_many :profiles

has_many :adminprofiles
  before_save :default_values

  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9]+\Z/
  validates :username, length: { maximum: 20, minimum: 3,
                                 message: "minimum char length is 3, max is 20" },
                       format: { with: VALID_USERNAME_REGEX,
                                 message: "Only letters and numbersallowed" },
                       uniqueness: { case_sensitive: false }



 class << self
   def authenticate(username, password)
     user = User.find_for_authentication(username: username)
     user.try(:valid_password?, password) ? user : nil
   end
 end
 

  def email_required?
    false
  end

  def email_changed?
    false
  end

 

  private
    def default_values
      self.enabled ||= false
      self.admin ||= false
    end
end
