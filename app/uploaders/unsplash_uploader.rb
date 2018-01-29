class UnsplashUploader < CarrierWave::Uploader::Base
  include Unsplash::CarrierWave

  version :thumb do
   process resize_to_fill: [60, 60]
  end

  version :fill_200 do
    process resize_to_fill: [200, 100]
  end

  version :medium do
   process resize_to_fit: [700, 320]
  end

  version :large do
   process resize_to_fit: [960,440]
  end

end