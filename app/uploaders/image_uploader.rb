# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  # http://cloudinary.com/blog/advanced_image_transformations_in_the_cloud_with_carrierwave_cloudinary
  version :thumb do
    process resize_to_fit: [200, 200]
  end

  version :thumb_landscape do
    process resize_to_fill: [200, 120]
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

  version :regular_landscape do
    process resize_to_fill: [1000, 400]
  end

  #custom sizes

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


  version :post_img do
    process resize_to_fit: [340, 220]
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