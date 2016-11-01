class CropUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  if Rails.env.production?
    include Cloudinary::CarrierWave
  end
  # Choose what kind of storage to use for this uploader:
  if Rails.env.development?
    storage :file
  #storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  def content_type_whitelist
    /image\//
  end
  # version :large do
  resize_to_limit(600,600)
  # end

  version :thumb do
    process :crop
    resize_to_fill(300, 240)
  end
  
  def crop
    if model.crop_x.present?
      resize_to_limit(600, 600)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

end