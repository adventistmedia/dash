# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  # http://cloudinary.com/blog/advanced_image_transformations_in_the_cloud_with_carrierwave_cloudinary
  version :thumb do
   process resize_to_fill: [60, 60]
   #cloudinary_transformation fetch_format: :auto Breaks images
  end

  version :fill_200 do
   process resize_to_fill: [200, 100]
   #cloudinary_transformation fetch_format: :auto
  end

  version :square_100 do
   process resize_to_fill: [100, 100]
   #cloudinary_transformation fetch_format: :auto
  end

  version :square_200 do
   process resize_to_fill: [200, 200]
   #cloudinary_transformation fetch_format: :auto
  end

  version :square_300 do
   process resize_to_fill: [300, 300]
   #cloudinary_transformation fetch_format: :auto
  end

  version :small do
   process resize_to_fit: [300, 200]
   #cloudinary_transformation fetch_format: :auto
  end

  version :post_img do
    process resize_to_fit: [340, 220]
    #cloudinary_transformation fetch_format: :auto
  end

  version :medium do
   process resize_to_fit: [700, 320]
   #cloudinary_transformation fetch_format: :auto
  end

  version :large do
   process resize_to_fit: [960,440]
   #cloudinary_transformation fetch_format: :auto
  end

  version :col_1 do
    process resize_to_fill: [300, 169]
    #cloudinary_transformation fetch_format: :auto
  end

  version :col_2 do
    process resize_to_fill: [300, 169]
    #cloudinary_transformation fetch_format: :auto
  end

  version :col_3 do
    process resize_to_fill: [400, 180]
    #cloudinary_transformation fetch_format: :auto
  end

  version :col_4 do
    process resize_to_fill: [400, 250]
    #cloudinary_transformation fetch_format: :auto
  end

  version :col_4_fit do
   process resize_to_fit: [400, 250]
   #cloudinary_transformation fetch_format: :auto
  end

  version :col_8 do
    process resize_to_fill: [727, 340]
    #cloudinary_transformation fetch_format: :auto
  end

  version :col_12 do
    process resize_to_fill: [960, 300]
    #cloudinary_transformation fetch_format: :auto
  end

end