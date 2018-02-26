module Dash::AssetConcern
  extend ActiveSupport::Concern

  included do
    include Dash::Tagit
    belongs_to :uploaded_by, class_name: Dash.user_class, optional: true

    searchable on: [:name, :content_type]
    searchable in: :tags, on: [:name]

    before_validation :set_published_on, on: :create
    validates :name, :type, :published_on, presence: true
    validates :credit_url, url: true, allow_blank: true

    before_create :update_asset_attributes
  end

  module ClassMethods

    def generate_uniq_filename(url)
      name = url.to_s.split('/').last.split('.').first
      name.gsub!('%20','_')
      name.gsub!(/\W/,'_')
      name.squeeze('_') + '_' + Time.now.to_i.to_s + SecureRandom.hex(5)
    end

  end

  def chooser_data
    data = {
      assettitle: name,
      asseturl: media.url.to_s,
      assetid: id,
      assetfilename: media_identifier.to_s,
    }
    if image?
      ["thumb", "small", "regular"].each{|s| data["asset#{s}".to_sym] = media.url(s).to_s }
      data[:assetoriginal] = media.url.to_s
    end
    data
  end

  def file_format
    self.content_type.to_s.split('/').last.to_s.upcase
  end

  def content_type?(content)
    content_type.include?(content)
  end

  def image?
    false
  end

  private

  def update_asset_attributes
    self.name = self.name.to_s.split('.').first.titleize.squeeze(' ')
  end

  def set_published_on
    self.published_on ||= Date.current
  end

end