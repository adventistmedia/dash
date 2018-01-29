class UnsplashUploader < CarrierWave::Uploader::Base
  include Unsplash::CarrierWave
  # default unsplash images
  version :thumb do
    process resize_to_fit: [200, 200]
  end

  version :thumb_square do
    process resize_to_fill: [200, 200]
  end

  version :small do
    process resize_to_fit: [400, 400]
  end

  version :regular do
    process resize_to_fit: [1080, 1080]
  end

end