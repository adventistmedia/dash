module Dash::UnsplashImageConcern
  extend ActiveSupport::Concern

  included do
    mount_uploader :media, UnsplashUploader
  end

  module ClassMethods

    def search(term, options={})
      #return [] if term.blank?
      if term.blank? && options[:collection].present?
        response = UnsplashApi.collection_photos(options.delete(:collection), options)
      elsif term.present?
        response = UnsplashApi.search(term, options)
      else
        response = UnsplashApi.all_photos(options)
      end
      results = []
      response["results"].each do |result|
        url = result["urls"]["raw"]
        if url[/photo\-[a-zA-Z0-9\_\-\.]+/] # hack to get aroung issue with reserve urls
          s = UnsplashImage.new(external_id: result["id"], name: result["description"])
          s.media.add_photo(url)
          results << s
        end
      end
      Kaminari.paginate_array(results, total_count: response["total"]).page(options[:page]).per(options[:per_page])
    end

    def setup_image(external_id, options={})
      options.reverse_merge!(external_id: external_id)
      photo = UnsplashApi.photo(external_id)
      UnsplashImage.where(options).first_or_initialize do |s|
        s.width = photo["width"]
        s.height = photo["height"]
        s.name = photo["description"].present? ? photo["description"] : external_id
        s.credit = "#{photo["user"]["name"]} / Unsplash"
        s.credit_url = "#{photo["user"]["links"]["html"]}?utm_source=adventistmedia&utm_medium=referral"
        s.media.add_photo(photo["urls"]["raw"])
        s.save
      end
    end

    def get_photo(external_id, options={})
      image = setup_image(external_id, options)
      if image.persisted?
        image.download
        image
      else
        nil
      end
    end

  end

  def url(size = :regular)
    media.url(size)
  end

  def image?
    true
  end

  def download
    UnsplashApi.delay.download(external_id)
  end

end