class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy

  validates :name, presence: true

  def self.add(name)
    name = name.to_s.downcase.gsub("'", "").parameterize.gsub("-", " ")
    Tag.where(name: name).first_or_create!
  end

end