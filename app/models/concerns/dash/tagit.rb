module Dash::Tagit
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").reject(&:blank?).map do |n|
      Tag.add(n)
    end.reject(&:blank?)
  end

end