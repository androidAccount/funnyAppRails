class Profile < ApplicationRecord
  belongs_to :user
mount_base64_uploader :image, AvatarUploaderUploader
end
