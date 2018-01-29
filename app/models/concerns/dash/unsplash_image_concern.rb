module Dash::UnsplashImageConcern
  extend ActiveSupport::Concern

  included do
    mount_uploader :media, UnsplashUploader
  end

  module ClassMethods

    def search(term, options={})
      return [] if term.blank?
      response = UnsplashApi.search(term, options)
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
      photo = UnsplashApi.photo(external_id)
      UnsplashImage.where(external_id: external_id).first_or_initialize do |s|
        s.width = photo["width"]
        s.height = photo["height"]
        s.name = photo["description"].present? ? photo["description"] : external_id
        s.credit = "#{photo["user"]["username"]} / Unsplash"
        s.credit_url = "#{photo["user"]["links"]["html"]}?utm_source=#{Rails.application.secrets.unsplash_utm_source}&utm_medium=referral"
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

    def to_chooser_json(results)
      assets_for_json = {}
      assets.each do |asset|
        assets_for_json[asset.id.to_s] = asset.chooser_json
      end
      assets_for_json
    end

  end

  def url(size = :large)
    media.url(size)
  end

  def image?
    true
  end

  def download
    UnsplashApi.delay.download(external_id)
  end

  def chooser_json
    details = {url: media.url.to_s, id: id, title: name, filename: media_identifier.to_s}
    if image?
      [:thumb, :regular, :large].each{|s| details[s] = media.send(s).url.to_s }
      details[:original] = media.url.to_s
    end
    details
  end

end