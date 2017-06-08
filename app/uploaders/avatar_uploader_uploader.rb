class AvatarUploaderUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  #storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "uploads/#{model.class.to_s.underscore}/#{model.id}/avatar"
  end
  def default_url(*args)
    "/images/default/empty_profile.png"
  end
  version :thumb do
    process :resize_to_fit => [50, 50]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    "#{secure_token(20)}.#{file.extension}" if original_filename.present?
  end
  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

end
