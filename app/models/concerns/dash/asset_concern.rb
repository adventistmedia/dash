module Dash::AssetConcern
  extend ActiveSupport::Concern

  included do
    include Dash::Tagit
    belongs_to :uploaded_by, class_name: Dash.user_class, optional: true

    searchable on: [:name, :content_type]
    searchable in: :tags, on: [:name]

    before_validation :set_published_on, on: :create
    validates :name, :type, :published_on, presence: true

    before_create :update_asset_attributes
  end

  module ClassMethods

    def to_chooser_json(assets)
      assets_for_json = {}
      assets.each do |asset|
        details = {url: asset.media.url.to_s, id: asset.id, title: asset.name, filename: asset.media_identifier.to_s}
        if asset.image?
          [:thumb, :medium, :large].each{|s| details[s] = asset.media.send(s).url.to_s }
          details[:original] = asset.media.url.to_s
        end
        assets_for_json[asset.id.to_s] = details
      end
      assets_for_json
    end

    def generate_uniq_filename(url)
      name = url.to_s.split('/').last.split('.').first
      name.gsub!('%20','_')
      name.gsub!(/\W/,'_')
      name.squeeze('_') + '_' + Time.now.to_i.to_s + SecureRandom.hex(5)
    end

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